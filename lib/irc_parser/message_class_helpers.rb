module IRCParser
  # This class methods generate helpers that are added to the
  # ParameterHelpers module created each time IRCParser::Message is inherited
  module MessageClassHelpers

    def alias_attr_accessor(aliases)
      aliases.each do |meth, aliases_collection|
        aliases_collection.each do |alias_name|
          alias_method(alias_name, meth)
          alias_method("#{alias_name}=", "#{meth}=")
        end
      end
    end

    def class_method_accessor(*accessors)
      accessors.each do |meth|
        class_eval(<<-METHODS, __FILE__, __LINE__)
          def #{meth}
            @_#{meth.to_s.sub(/!$/, "_bang").sub(/\?$/, "_query")} ||= self.class.#{meth}
          end
        METHODS
      end
    end

    def parameter(name, options = {})
      parameter_index = default_parameters.length

      default_parameters << name and return unless name.is_a?(Symbol)

      if options[:csv]
        sep = ( options[:separator] ? options[:separator] : "," ).inspect

        const_get("ParameterHelpers").module_eval(<<-METHODS, __FILE__, __LINE__)
          def #{name}
            (val = @parameters[#{parameter_index}]) ? val.split(#{sep}) : []
          end

          def #{name}=(val)
            @parameters[#{parameter_index}] = Array(val).join(#{sep})
          end
        METHODS
      else
        const_get("ParameterHelpers").module_eval(<<-METHODS, __FILE__, __LINE__)
          def #{name}
            @parameters[#{parameter_index}]
          end

          def #{name}=(val)
            @parameters[#{parameter_index}] = val
          end
        METHODS
      end

      alias_attr_accessor(name => options[:aliases]) if options[:aliases]

      default_parameters << (options.member?(:default) ? options[:default] : nil)
    end

    def parameters(*names)
      self.postfixes = names.last.length if names.last.is_a?(Array)
      names.flatten.each { |name| parameter(name) }
    end

  end
end
