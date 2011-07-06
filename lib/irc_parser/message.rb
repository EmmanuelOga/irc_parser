module IRCParser
  class Message
    require 'irc_parser/message_class_config'
    extend IRCParser::MessageClassConfig

    attr_accessor :prefix
    attr_reader :parameters

    def initialize(prefix = nil, params = nil)
      @prefix, @parameters = prefix, Params.new(self.class.default_parameters, params)
      yield self if block_given?
    end

    def to_s
      "#{prefix ? ":#{prefix} " : nil}#{self.class.identifier}#{parameters.to_s(self.class.postfixes)}\r\n"
    end
    alias_method :to_str, :to_s
  end
end
