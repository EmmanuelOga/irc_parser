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

    def class_method_accessor(*accessors)
      methods = accessors.map do |meth|
        <<-METHODS
          def #{meth}
            self.class.#{meth}
          end
        METHODS
      end
      include Module.new.tap {|m| m.module_eval(methods.join(" "), __FILE__, __LINE__) }
    end

    def parameter(name, options = {})
      parameter_index = default_parameters.length

      default_parameters << name and return unless name.is_a?(Symbol)

      include Module.new.tap {|m| m.module_eval(<<-METHODS, __FILE__, __LINE__) }
        def #{name}
          @parameters[#{parameter_index}]
        end

        def #{name}=(val)
          @parameters[#{parameter_index}] = val
        end
      METHODS

      sep = ( options[:separator] ? options[:separator] : "," ).inspect if options[:csv]

      include Module.new.tap {|m| m.module_eval(<<-METHODS, __FILE__, __LINE__) } if options[:csv]
        def #{name}
          (val = super) ? val.split(#{sep}) : []
        end

        def #{name}=(val)
          super((val = Array(val).join(#{sep})) == "" ? nil : val)
        end
      METHODS

      alias_attr_accessor(name => options[:aliases]) if options[:aliases]

      default_parameters << (options.member?(:default) ? options[:default] : nil)
    end

    def parameters(*names)
      self.postfixes = names.last.length if names.last.is_a?(Array)
      names.flatten.each { |name| parameter(name) }
    end

  end
end
