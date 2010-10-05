module IRCParser
  class Message
    require 'irc_parser/message_class_helpers'
    extend IRCParser::MessageClassHelpers

    attr_accessor :prefix
    attr_reader :parameters

    alias_attr_accessor :prefix => [:from, :who, :target]

    class << self
      attr_reader :identifier
      attr_accessor :postfixes, :to_sym

      def identifier=(ident)
        IRCParser::Messages::ALL[@identifier = ident] = self
      end

      private :identifier=, :postfixes=, :to_sym=
    end

    def self.class_name
      @_class_name ||= name.split("::").last
    end

    def self.is_reply?
      @_is_reply ||= class_name =~ /^Rpl[A-Z]/
    end

    def self.is_error?
      @_is_error ||= class_name =~ /^Err[A-Z]/
    end

    def self.inherited(klass)
      ident = klass.class_name
      symbol = IRCParser::Helper.underscore(ident).to_sym

      klass.class_eval do
        self.postfixes  = 0
        self.identifier = ident
        self.identifier = ident.upcase
        self.identifier = symbol
        self.identifier = symbol.to_s

        self.to_sym = symbol

        # Last one: order is important (last one is used in to_s to identify the msg)
        self.identifier = ident.upcase
      end
    end

    def self.default_parameters
      @predefined_params ||= []
    end

    def initialize(prefix = nil, params = nil)
      self.prefix, @parameters = prefix, Params.new(default_parameters, params)
      yield self if block_given?
    end

    class_method_accessor :class_name, :identifier, :default_parameters, :postfixes, :is_reply?, :is_error?, :to_sym

    def to_s
      "#{prefix ? ":#{prefix} " : nil}#{identifier}#{parameters.to_s(postfixes)}\r\n"
    end
    alias_method :to_str, :to_s
  end
end
