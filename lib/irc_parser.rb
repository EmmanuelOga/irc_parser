module IRCParser
  VERSION = "0.0.1"

  autoload :Helper, 'irc_parser/helper'
  autoload :Params, 'irc_parser/params'
  autoload :Messages, 'irc_parser/messages'

  require 'irc_parser/parser'

  def message(identifier, prefix = nil, params = nil)
    klass = Messages::ALL[identifier]
    raise IRCParser::Parser::Error, "Message not recognized: #{message.inspect}" unless klass
    obj = klass.new(prefix, params)
    yield obj if block_given?
    obj
  end

  def message_class(identifier)
    klass = Messages::ALL[identifier]
    raise ArgumentError.new("no message with identifier #{identifier.inspect}") unless klass
    klass
  end

  extend self
end
