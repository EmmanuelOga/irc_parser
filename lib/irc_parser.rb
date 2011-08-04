module IRCParser
  extend self

  VERSION = "0.0.1"

  autoload :Parser, 'irc_parser/parser'
  autoload :Helper, 'irc_parser/helper'
  autoload :Params, 'irc_parser/params'
  autoload :Message, 'irc_parser/message'

  def parse(message)
    prefix, identifier, params = Parser.run(message)
    Messages::ALL[identifier].new(prefix, params)
  rescue
    raise IRCParser::Parser::Error.new("No such message class #{message.inspect}", message, prefix, identifier, params)
  end

  def message(identifier, prefix = nil, params = nil)
    obj = message_class(identifier).new(prefix, params)
    yield obj if block_given?
    obj
  end

  def message_class(identifier)
    klass = Messages::ALL[identifier]
    raise ArgumentError.new("no message with identifier #{identifier.inspect}") unless klass
    klass
  end
end

require 'irc_parser/messages'
