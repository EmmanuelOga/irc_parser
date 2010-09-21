module IRCParser
  module MessageClassHelpers

    def alias_attr_accessor(aliases)
      aliases.each do |meth, aliases_collection|
        aliases_collection.each do |alias_name|
          alias_method(alias_name, meth)
          alias_method("#{alias_name}=", "#{meth}=")
        end
      end
    end

    def parameter(name, options = {})
      parameter_index = default_parameters.length

      default_parameters << name and return unless name.is_a?(Symbol)

      include Module.new.tap {|m| m.module_eval(<<-METHODS, __FILE__, __LINE__) }
        def #{name}
          ( val = @parameters[#{parameter_index}] ) == IRCParser::Params::PLACEHOLDER ? nil : val
        end

        def #{name}=(val)
          @parameters[#{parameter_index}] = val
        end

        def #{name}_given?
          @parameters[#{parameter_index}] != IRCParser::Params::PLACEHOLDER
        end
      METHODS

      include Module.new.tap {|m| m.module_eval(<<-METHODS, __FILE__, __LINE__) } if options[:csv]
        def #{name}
          (val = super) ? val.split(",") : Array.new
        end

        def #{name}=(val)
          super((val = Array(val).join(",")) == "" ? nil : val)
        end
      METHODS

      if options[:aliases]
        alias_attr_accessor(name => options[:aliases])
        options[:aliases].each { |alias_name| alias_method("#{alias_name}_given?", "#{name}_given?") }
      end

      if options.member?(:default)
        default_parameters << options[:default]
      elsif options[:csv]
        default_parameters << nil
      else
        default_parameters << IRCParser::Params::PLACEHOLDER
      end
    end

    def parameters(*names)
      self.postfixes = names.last.length if names.last.is_a?(Array)
      names.flatten.each { |name| parameter(name) }
    end

  end
end
