module IRCParser
  extend self

  VERSION = "0.0.1"

  autoload :Parser, "irc_parser/parser"
  autoload :Helper, "irc_parser/helper"
  autoload :Params, 'irc_parser/params'
  autoload :Message, 'irc_parser/message'
  autoload :Messages, 'irc_parser/messages'

  def parse(message)
    prefix, identifier, params = Parser.run(message)

    klass = Messages::ALL[identifier.upcase]

    raise IRCParser::Parser::Error.new("looking up message class", message, prefix, identifier, params) unless klass

    klass.new(prefix, params)
  end

  def message(identifier, prefix = nil, params = nil, &block)
    message_class(identifier).new(prefix, params, &block)
  end

  def message_class(identifier)
    klass = Messages::ALL[identifier]
    raise ArgumentError.new("no message with identifier #{identifier.inspect}") unless klass
    klass
  end
end
