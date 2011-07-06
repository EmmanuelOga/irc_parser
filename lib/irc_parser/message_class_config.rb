module IRCParser
  module MessageClassConfig
    attr_reader :identifier, :postfixes, :to_sym

    def class_name
      @_class_name ||= name.split("::").last
    end

    def is_reply?
      @_is_reply ||= class_name =~ /^Rpl[A-Z]/
    end

    def is_error?
      @_is_error ||= class_name =~ /^Err[A-Z]/
    end

    def identify_as(ident)
      IRCParser::Messages::ALL[ident] = self
      @identifier = ident
    end

    def inherited(klass)
      ident = klass.class_name
      symbol = IRCParser::Helper.underscore(ident).to_sym
      [ident, symbol, symbol.to_s, ident.upcase].each { |name| klass.identify_as(name) }
      klass.instance_variable_set("@to_sym", symbol)
      klass.instance_variable_set("@postfixes", 0)
    end

    def default_parameters
      @default_parameters ||= []
    end

    def parameter(name, options = {})
      parameter_index = default_parameters.length

      default_parameters << name and return unless name.is_a?(Symbol)

      if options[:csv]
        sep = ( options[:separator] ? options[:separator] : "," ).inspect

        class_eval(<<-METHODS, __FILE__, __LINE__)
          def #{name}
            (val = @parameters[#{parameter_index}]) ? val.split(#{sep}) : []
          end

          def #{name}=(val)
            @parameters[#{parameter_index}] = Array(val).join(#{sep})
          end
        METHODS
      else
        class_eval(<<-METHODS, __FILE__, __LINE__)
          def #{name}
            @parameters[#{parameter_index}]
          end

          def #{name}=(val)
            @parameters[#{parameter_index}] = val
          end
        METHODS
      end

      default_parameters << (options.member?(:default) ? options[:default] : nil)
    end

    def parameters(*names)
      @postfixes = names.last.length if names.last.is_a?(Array)
      names.flatten.each { |name| parameter(name) }
    end
  end
end
