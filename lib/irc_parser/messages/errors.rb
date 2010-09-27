class IRCParser::Messages::ErrNoSuchNick < IRCParser::Message
  self.identifier = "401"
  parameters :nick, :user_nick, "No such nick/channel"
end

class IRCParser::Messages::ErrNoSuchServer < IRCParser::Message
  self.identifier = "402"
  parameters :server, "No such server"
end

class IRCParser::Messages::ErrNoSuchChannel < IRCParser::Message
  self.identifier = "403"
  parameters :channel, "No such channel"
end

class IRCParser::Messages::ErrCannotSendToChan < IRCParser::Message
  self.identifier = "404"
  parameters :channel, "Cannot send to channel"
end

class IRCParser::Messages::ErrTooManyChannels < IRCParser::Message
  self.identifier = "405"
  parameters :channel, "You have joined too many channels"
end

class IRCParser::Messages::ErrWasNoSuchNick < IRCParser::Message
  self.identifier = "406"
  parameters :nick, "There was no such nickname"
end

class IRCParser::Messages::ErrTooManyTargets < IRCParser::Message
  self.identifier = "407"
  parameters :target, "Duplicate recipients. No message delivered"
end

class IRCParser::Messages::ErrNoOrigin < IRCParser::Message
  self.identifier = "409"
  parameters "No origin specified"
end

class IRCParser::Messages::ErrNoRecipient < IRCParser::Message
  self.identifier = "411"
  parameters "No recipient given (", :command, ")"

  def initialize(prefix, *params)
    super(prefix, [])
    self.command = ( params.to_s =~ /\(([^\)]+)\)/ && $1 )
  end

  def to_str
    "#{identifier} :No recipient given (#{command})\r\n"
  end
  alias_method :to_s, :to_str
end

class IRCParser::Messages::ErrNoTextToSend < IRCParser::Message
  self.identifier = "412"
  parameters "No text to send"
end

class IRCParser::Messages::ErrNoTopLevel < IRCParser::Message
  self.identifier = "413"
  parameters :mask, "No toplevel domain specified"
end

class IRCParser::Messages::ErrWildTopLevel < IRCParser::Message
  self.identifier = "414"
  parameters :mask, "Wildcard in toplevel domain"
end

class IRCParser::Messages::ErrUnknownCommand < IRCParser::Message
  self.identifier = "421"
  parameters :command, "Unknown command"
end

class IRCParser::Messages::ErrNoMotd < IRCParser::Message
  self.identifier = "422"
  parameters "MOTD File is missing"
end

class IRCParser::Messages::ErrNoAdminInfo < IRCParser::Message
  self.identifier = "423"
  parameters :server, "No administrative info available"
end

class IRCParser::Messages::ErrFileError < IRCParser::Message
  self.identifier = "424"
  parameters "File error doing", :file_op, "on", :file do
  end

  def initialize(prefix, *params)
    super(prefix, [])
    self.file_op, self.file = $1, $2 if params.join(" ") =~ /^File error doing\s+([^ ]+)\s+on\s+([^ ]+)/
  end

  def to_str
    "#{identifier} :File error doing #{file_op} on #{file}\r\n"
  end
  alias_method :to_s, :to_str
end

class IRCParser::Messages::ErrNoNickNameGiven < IRCParser::Message
  self.identifier = "431"
  parameters "No nickname given"
end

class IRCParser::Messages::ErrErroneusNickName < IRCParser::Message
  self.identifier = "432"
  parameters :nick, "Erroneus nickname"
end

class IRCParser::Messages::ErrNickNameInUse < IRCParser::Message
  self.identifier = '433'
  parameters :nick, "Nickname is already in use"
end

class IRCParser::Messages::ErrNickCollision < IRCParser::Message
  self.identifier = '436'
  parameters :nick, "Nickname collision KILL"
end

class IRCParser::Messages::ErrUserNotInChannel < IRCParser::Message
  self.identifier = '441'
  parameters :nick, :channel, "They aren't on that channel"
end

class IRCParser::Messages::ErrNotOnChannel < IRCParser::Message
  self.identifier = '442'
  parameters :channel, "You're not on that channel"
end

class IRCParser::Messages::ErrUserOnChannel < IRCParser::Message
  self.identifier = '443'
  parameters :user, :channel, "is already on channel"
end

class IRCParser::Messages::ErrNoLogin < IRCParser::Message
  self.identifier = '444'
  parameters :user, "User not logged in"
end

class IRCParser::Messages::ErrSummonDisabled < IRCParser::Message
  self.identifier = '445'
  parameters "SUMMON has been disabled"
end

class IRCParser::Messages::ErrUsersDisabled < IRCParser::Message
  self.identifier = '446'
  parameters "USERS has been disabled"
end

class IRCParser::Messages::ErrNotRegistered < IRCParser::Message
  self.identifier = '451'
  parameters "You have not registered"
end

class IRCParser::Messages::ErrNeedMoreParams < IRCParser::Message
  self.identifier = '461'
  parameters :command, "Not enough parameters"
end

class IRCParser::Messages::ErrAlreadyRegistred < IRCParser::Message
  self.identifier = '462'
  parameters "You may not reregister"
end

class IRCParser::Messages::ErrNoPermForHost < IRCParser::Message
  self.identifier = '463'
  parameters "Your host isn't among the privileged"
end

class IRCParser::Messages::ErrPasswdMismatch < IRCParser::Message
  self.identifier = '464'
  parameters "Password incorrect"
end

class IRCParser::Messages::ErrYouReBannedCreep < IRCParser::Message
  self.identifier = '465'
  parameters "You are banned from this server"
end

class IRCParser::Messages::ErrKeySet < IRCParser::Message
  self.identifier = '467'
  parameters :channel, "Channel key already set"
end

class IRCParser::Messages::ErrChannelIsFull < IRCParser::Message
  self.identifier = '471'
  parameters :channel, "Cannot join channel (+l)"
end

class IRCParser::Messages::ErrUnknownMode < IRCParser::Message
  self.identifier = '472'
  parameters :char, "is unknown mode char to me"
end

class IRCParser::Messages::ErrInviteOnLYChan < IRCParser::Message
  self.identifier = '473'
  parameters :channel, "Cannot join channel (+i)"
end

class IRCParser::Messages::ErrBannedFromChan < IRCParser::Message
  self.identifier = '474'
  parameters :channel, "Cannot join channel (+b)"
end

class IRCParser::Messages::ErrBadChannelKey < IRCParser::Message
  self.identifier = '475'
  parameters :channel, "Cannot join channel (+k)"
end

class IRCParser::Messages::ErrNoPrivileges < IRCParser::Message
  self.identifier = '481'
  parameters "Permission Denied- You're not an IRC operator"
end

class IRCParser::Messages::ErrChanOPrivsNeeded < IRCParser::Message
  self.identifier = '482'
  parameters :channel, "You're not channel operator"
end

class IRCParser::Messages::ErrCantKillServer < IRCParser::Message
  self.identifier = '483'
  parameters "You cant kill a server!"
end

class IRCParser::Messages::ErrNoOperHost < IRCParser::Message
  self.identifier = '491'
  parameters "No O-lines for your host"
end

class IRCParser::Messages::ErrUModeUnknownFlag < IRCParser::Message
  self.identifier = '501'
  parameters "Unknown MODE flag"
end

class IRCParser::Messages::ErrUsersDontMatch < IRCParser::Message
  self.identifier = '502'
  parameters "Cant change mode for other users"
end

# Not Used / Reserved ( http://tools.ietf.org/html/rfc1459#section-6.3
# IRCParser::Messages::YouWillBeBanned
# IRCParser::Messages::BadChanMask
# IRCParser::Messages::NoServiceHost
