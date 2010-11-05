module IRCParser
  module MessageClassHelpers

    def class_method_accessor(*accessors)
      accessors.each do |meth|
        class_eval(<<-METHODS, __FILE__, __LINE__)
          def #{meth}(*args, &block)
            self.class.#{meth}(*args, &block)
          end
        METHODS
      end
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
      self.postfixes = names.last.length if names.last.is_a?(Array)
      names.flatten.each { |name| parameter(name) }
    end

  end
end
