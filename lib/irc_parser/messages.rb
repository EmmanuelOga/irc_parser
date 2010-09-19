module IRCParser
  module Messages
    ALL = Hash.new
  end
end

require 'irc_parser/messages/commands'
require 'irc_parser/messages/errors'
require 'irc_parser/messages/replies'
