class IRCParser::Messages::ErrNoSuchNick < IRCParser::Message
  self.identifier = "401"
  parameters :nick, :error_nick, "No such nick/channel"
end

class IRCParser::Messages::ErrNoSuchServer < IRCParser::Message
  self.identifier = "402"
  parameters :nick, :server, "No such server"
end

class IRCParser::Messages::ErrNoSuchChannel < IRCParser::Message
  self.identifier = "403"
  parameters :nick, :channel, "No such channel"
end

class IRCParser::Messages::ErrCannotSendToChan < IRCParser::Message
  self.identifier = "404"
  parameters :nick, :channel, "Cannot send to channel"
end

class IRCParser::Messages::ErrTooManyChannels < IRCParser::Message
  self.identifier = "405"
  parameters :nick, :channel, "You have joined too many channels"
end

class IRCParser::Messages::ErrWasNoSuchNick < IRCParser::Message
  self.identifier = "406"
  parameters :nick, :error_nick, "There was no such nickname"
end

class IRCParser::Messages::ErrTooManyTargets < IRCParser::Message
  self.identifier = "407"
  parameters :nick, :target, "Duplicate recipients. No message delivered"
end

class IRCParser::Messages::ErrNoOrigin < IRCParser::Message
  self.identifier = "409"
  parameters :nick, "No origin specified"
end

class IRCParser::Messages::ErrNoRecipient < IRCParser::Message
  self.identifier = "411"
  parameters :nick, "No recipient given (", :command, ")"

  def initialize(prefix, params = nil)
    super
    self.command = ( params.to_s =~ /\(([^\)]+)\)/ && $1 ) if params
  end

  def to_str
    "#{identifier} #{nick} :No recipient given (#{command})\r\n"
  end
  alias_method :to_s, :to_str
end

class IRCParser::Messages::ErrNoTextToSend < IRCParser::Message
  self.identifier = "412"
  parameters :nick, "No text to send"
end

class IRCParser::Messages::ErrNoTopLevel < IRCParser::Message
  self.identifier = "413"
  parameters :nick, :mask, "No toplevel domain specified"
end

class IRCParser::Messages::ErrWildTopLevel < IRCParser::Message
  self.identifier = "414"
  parameters :nick, :mask, "Wildcard in toplevel domain"
end

class IRCParser::Messages::ErrUnknownCommand < IRCParser::Message
  self.identifier = "421"
  parameters :nick, :command, "Unknown command"
end

class IRCParser::Messages::ErrNoMotd < IRCParser::Message
  self.identifier = "422"
  parameters :nick, "MOTD File is missing"
end

class IRCParser::Messages::ErrNoAdminInfo < IRCParser::Message
  self.identifier = "423"
  parameters :nick, :server, "No administrative info available"
end

class IRCParser::Messages::ErrFileError < IRCParser::Message
  self.identifier = "424"
  parameters :nick, ["File error doing", :file_op, "on", :file]

  def initialize(prefix, params = nil)
    super
    self.file_op, self.file = $1, $2 if params && params.join(" ") =~ /File error doing\s*([^ ]+)\s*on\s*([^ ]+)/
  end
end

class IRCParser::Messages::ErrNoNickNameGiven < IRCParser::Message
  self.identifier = "431"
  parameters :nick, "No nickname given"
end

class IRCParser::Messages::ErrErroneusNickName < IRCParser::Message
  self.identifier = "432"
  parameters :nick, :error_nick, "Erroneus nickname"
end

class IRCParser::Messages::ErrNickNameInUse < IRCParser::Message
  self.identifier = '433'
  parameters :nick, :error_nick, "Nickname is already in use"
end

class IRCParser::Messages::ErrNickCollision < IRCParser::Message
  self.identifier = '436'
  parameters :nick, :error_nick, "Nickname collision KILL"
end

class IRCParser::Messages::ErrUserNotInChannel < IRCParser::Message
  self.identifier = '441'
  parameters :nick, :error_nick, :channel, "They aren't on that channel"
end

class IRCParser::Messages::ErrNotOnChannel < IRCParser::Message
  self.identifier = '442'
  parameters :nick, :channel, "You're not on that channel"
end

class IRCParser::Messages::ErrUserOnChannel < IRCParser::Message
  self.identifier = '443'
  parameters :nick, :user, :channel, "is already on channel"
end

class IRCParser::Messages::ErrNoLogin < IRCParser::Message
  self.identifier = '444'
  parameters :nick, :user, "User not logged in"
end

class IRCParser::Messages::ErrSummonDisabled < IRCParser::Message
  self.identifier = '445'
  parameters :nick, "SUMMON has been disabled"
end

class IRCParser::Messages::ErrUsersDisabled < IRCParser::Message
  self.identifier = '446'
  parameters :nick, "USERS has been disabled"
end

class IRCParser::Messages::ErrNotRegistered < IRCParser::Message
  self.identifier = '451'
  parameters :nick, "You have not registered"
end

class IRCParser::Messages::ErrNeedMoreParams < IRCParser::Message
  self.identifier = '461'
  parameters :nick, :command, "Not enough parameters"
end

class IRCParser::Messages::ErrAlreadyRegistred < IRCParser::Message
  self.identifier = '462'
  parameters :nick, "You may not reregister"
end

class IRCParser::Messages::ErrNoPermForHost < IRCParser::Message
  self.identifier = '463'
  parameters :nick, "Your host isn't among the privileged"
end

class IRCParser::Messages::ErrPasswdMismatch < IRCParser::Message
  self.identifier = '464'
  parameters :nick, "Password incorrect"
end

class IRCParser::Messages::ErrYouReBannedCreep < IRCParser::Message
  self.identifier = '465'
  parameters :nick, "You are banned from this server"
end

class IRCParser::Messages::ErrKeySet < IRCParser::Message
  self.identifier = '467'
  parameters :nick, :channel, "Channel key already set"
end

class IRCParser::Messages::ErrChannelIsFull < IRCParser::Message
  self.identifier = '471'
  parameters :nick, :channel, "Cannot join channel (+l)"
end

class IRCParser::Messages::ErrUnknownMode < IRCParser::Message
  self.identifier = '472'
  parameters :nick, :char, "is unknown mode char to me"
end

class IRCParser::Messages::ErrInviteOnLYChan < IRCParser::Message
  self.identifier = '473'
  parameters :nick, :channel, "Cannot join channel (+i)"
end

class IRCParser::Messages::ErrBannedFromChan < IRCParser::Message
  self.identifier = '474'
  parameters :nick, :channel, "Cannot join channel (+b)"
end

class IRCParser::Messages::ErrBadChannelKey < IRCParser::Message
  self.identifier = '475'
  parameters :nick, :channel, "Cannot join channel (+k)"
end

class IRCParser::Messages::ErrNoPrivileges < IRCParser::Message
  self.identifier = '481'
  parameters :nick, "Permission Denied- You're not an IRC operator"
end

class IRCParser::Messages::ErrChanOPrivsNeeded < IRCParser::Message
  self.identifier = '482'
  parameters :nick, :channel, "You're not channel operator"
end

class IRCParser::Messages::ErrCantKillServer < IRCParser::Message
  self.identifier = '483'
  parameters :nick, "You cant kill a server!"
end

class IRCParser::Messages::ErrNoOperHost < IRCParser::Message
  self.identifier = '491'
  parameters :nick, "No O-lines for your host"
end

class IRCParser::Messages::ErrUModeUnknownFlag < IRCParser::Message
  self.identifier = '501'
  parameters :nick, "Unknown MODE flag"
end

class IRCParser::Messages::ErrUsersDontMatch < IRCParser::Message
  self.identifier = '502'
  parameters :nick, "Cant change mode for other users"
end

# Not Used / Reserved ( http://tools.ietf.org/html/rfc1459#section-6.3
# IRCParser::Messages::YouWillBeBanned
# IRCParser::Messages::BadChanMask
# IRCParser::Messages::NoServiceHost
