module IRCParser
  class Message
    require 'irc_parser/message_class_helpers'
    extend IRCParser::MessageClassHelpers

    attr_accessor :prefix
    attr_reader :parameters

    alias_attr_accessor :prefix => [:from, :who, :target]

    class << self
      attr_reader :identifier
      attr_accessor :postfixes

      def identifier=(ident)
        IRCParser::Messages::ALL[@identifier = ident] = self
      end

      private :identifier=, :postfixes=
    end

    def self.inherited(klass)
      ident = klass.name.split("::").last

      klass.class_eval do
        self.identifier = ident
        self.identifier = ident.upcase
        self.identifier = IRCParser::Helper.underscore(ident)

        # Last one: order is important (last one is used in to_s to identify the msg)
        self.identifier = ident.upcase
      end
    end

    def self.default_parameters
      @predefined_params ||= Array.new
    end

    def identifier
      self.class.identifier
    end

    def initialize(prefix = nil, *params)
      self.prefix = prefix
      @parameters = Params.new(self.class.default_parameters, self.class.postfixes)
      params.each_with_index { |val, index| @parameters[index] = val }
      yield self if block_given?
    end

    def to_str
      params = respond_to?(:process_parameters) ? process_parameters(parameters) : parameters
      "#{prefix ? ":#{prefix}" : nil} #{identifier} #{params}".strip << "\r\n"
    end

    alias_method :to_s, :to_str
  end
end
