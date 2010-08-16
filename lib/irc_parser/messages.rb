module IRCParser
  module Messages
    CLASS_FOR_IDENTIFIER = Hash.new

    MESSAGES = Hash.new
    REPLIES = Hash.new
    ERRORS = Hash.new

    class Message
      require 'irc_parser/message_definition_helpers'
      extend IRCParser::MessageDefinitionHelpers

      attr_reader :params
      attr_accessor :prefix

      alias_method :from, :prefix
      alias_method :from=, :prefix=

      def self.predefined_params
        @predefined_params ||= Hash.new
      end

      def initialize
        @params = Params.new(self.class.predefined_params, postfixes)

        yield self if block_given?
      end

      def initialize_params(vals)
        vals.each_with_index { |val, index| params[index] = val }
      end

      def has_name_or_numeric?(name_or_numeric)
        ( respond_to?(:numeric) && name_or_numeric == numeric ) || name_or_numeric == name
      end

      def msg_ident
        respond_to?(:numeric) ? numeric : name
      end

      def to_str
        parameters = respond_to?(:process_parameters) ? process_parameters(params) : params
        "#{prefix ? ":#{prefix}" : nil} #{msg_ident} #{parameters}".strip << "\r\n"
      end
      alias_method :to_s, :to_str
    end
  end

  require "irc_parser/message_accessors"
  extend MessageAccessors

  def parse(message)
    prefix, identifier, *params = Parser.run(message)

    klass = Messages::CLASS_FOR_IDENTIFIER[identifier.upcase]

    raise IRCParser::Parser::Error.new(message, prefix, identifier, params) unless klass

    klass.new do |message|
      message.prefix = prefix
      message.initialize_params(params)
    end
  end

  require 'irc_parser/definitions/messages'
  require 'irc_parser/definitions/errors'
  require 'irc_parser/definitions/replies'
end
