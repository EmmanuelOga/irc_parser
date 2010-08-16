module IRCParser
  VERSION = "0.0.1"

  autoload :Parser   , "irc_parser/parser"
  autoload :RFC      , "irc_parser/rfc"
  autoload :Params   , 'irc_parser/params'

  extend self
end
