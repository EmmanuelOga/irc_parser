module IRCParser
  module MessageAccessors

    [[:reply, :replies], [:error, :errors], [:message, :messages]].each do |singular, plural|
      module_eval(<<-METHODS, __FILE__, __LINE__)
        def #{singular}(identifier, &block)
          klass = Messages::CLASS_FOR_IDENTIFIER[identifier]
          klass ||= IRCParser::Messages::#{plural.upcase}[identifier]
          raise ArgumentError, "Unknown #{singular}: \#{identifier.inspect}" unless klass
          klass.new.tap { |object| yield object if block_given? }
        end

        def #{singular}_class_eval(*names, &block)
          names.each do |name|
            IRCParser::Messages::#{plural.upcase}[name].tap do |klass|
              klass.class_eval(&block) if block
            end
          end
        end

        def #{plural}(*args)
          args.map {|name| #{singular}(name) }
        end
      METHODS
    end

    def numeric_for_error(identifier)
      klass = Messages::CLASS_FOR_IDENTIFIER[identifier]
      klass ||= IRCParser::Messages::ERRORS[identifier]
      klass.const_get(:NUMERIC) if klass && klass.constants.include?(:NUMERIC)
    end

    def numeric_for_reply(identifier)
      klass = Messages::CLASS_FOR_IDENTIFIER[identifier]
      klass ||= IRCParser::Messages::REPLIES[identifier]
      klass.const_get(:NUMERIC) if klass && klass.constants.include?(:NUMERIC)
    end

  end
end
