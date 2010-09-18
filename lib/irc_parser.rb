module IRCParser
  extend self

  VERSION = "0.0.1"

  autoload :Parser, "irc_parser/parser"
  autoload :Helper, "irc_parser/helper"
  autoload :Params, 'irc_parser/params'

  def parse(message)
    prefix, identifier, *params = Parser.run(message)

    klass = Messages::CLASS_FOR_IDENTIFIER[identifier.upcase]

    raise IRCParser::Parser::Error.new(message, prefix, identifier, params) unless klass

    klass.new do |message|
      message.prefix = prefix
      message.initialize_params(params)
    end
  end
end
