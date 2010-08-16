module IRCParser
  module MessageDefinitionHelpers

    def create_message_class(class_name, message_name, postfixes)
      klass = Class.new(IRCParser::Messages::Message)
      klass.class_eval(<<-NAME_METH, __FILE__, __LINE__)
        POSTFIXES = #{postfixes}
        def postfixes
          POSTFIXES
        end
        private :postfixes

        NAME = '#{message_name}'.freeze
        def name
          NAME
        end
      NAME_METH
      IRCParser::Messages.const_set("#{class_name}", klass)
      klass
    end

    def define_message(*klasses, &block)
      klasses.each do |name|
        klass = create_message_class(name, name.to_s.upcase, 0)
        IRCParser::Messages::CLASS_FOR_IDENTIFIER[name.to_s.upcase] = klass
        IRCParser::Messages::MESSAGES[underscore(name).to_sym] = klass
        klass.class_eval(&block) if block
      end
    end

    def define_special_message(name, numeric, class_prefix, name_prefix, *args, &block)
      postfixes = args.last.is_a?(Hash) ? args.pop[:postfixes] : 0

      klass = create_message_class("#{class_prefix}#{name}", "#{name_prefix}#{name}".upcase, postfixes)

      IRCParser::Messages::CLASS_FOR_IDENTIFIER[numeric] = klass

      klass.class_eval(<<-NAME_METH, __FILE__, __LINE__)
        NUMERIC = '#{numeric.to_s.upcase}'.freeze
        def numeric
          NUMERIC
        end
      NAME_METH

      args.each_with_index do |meth_or_val, index|
        klass.param_means(meth_or_val, :index => index)
      end

      klass.class_eval(&block) if block
      klass
    end

    def define_error(name, numeric, *args, &block)
      klass = define_special_message(name, numeric, "Err", "ERR_", *args, &block)
      IRCParser::Messages::ERRORS[underscore(name).to_sym] = klass
    end

    def define_reply(name, numeric, *args, &block)
      klass = define_special_message(name, numeric, "Rpl", "RPL_", *args, &block)
      IRCParser::Messages::REPLIES[underscore(name).to_sym] = klass
    end

    # meaning :: a symbol with the name of the attribute method
    #
    # Options:
    #
    # index   :: index of parameter to alias
    # meaning :: name for the alias (if meaning is a sym) value for the index otherwise
    # aliases :: aliases for the method (if meaning is a sym)
    # default :: value used on initialization
    def param_means(meaning, options)
      if meaning.is_a?(Symbol)

        methods = [meaning] + (options[:aliases] || Array.new)

        methods.each do |meth|
          mod = Module.new

          if options[:csv]
            mod.module_eval(<<-METHODS, __FILE__, __LINE__)
              def #{meth}
                val = params[#{options[:index]}]
                ( val == IRCParser::Params::PLACEHOLDER ) ? Array.new : val.split(",")
              end

              def #{meth}=(val)
                new_val = Array(val).join(",")
                params[#{options[:index]}] = ( new_val == "" ) ? IRCParser::Params::PLACEHOLDER : new_val
              end

              def #{meth}_given?
                params[#{options[:index]}] != IRCParser::Params::PLACEHOLDER
              end
            METHODS
          else
            mod.module_eval(<<-METHODS, __FILE__, __LINE__)
              def #{meth}
                val = params[#{options[:index]}]
                ( val == IRCParser::Params::PLACEHOLDER ) ? nil : val
              end

              def #{meth}=(val)
                params[#{options[:index]}] = val
              end

              def #{meth}_given?
                params[#{options[:index]}] != IRCParser::Params::PLACEHOLDER
              end
            METHODS
          end

          include(mod)
        end

        predefined_params[options[:index]] = (options[:default] || IRCParser::Params::PLACEHOLDER)
      else
        predefined_params[options[:index]] = meaning
      end
    end

    def underscore(string)
      string.to_s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
    end
    private :underscore

  end
end
