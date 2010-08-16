IRCParser::Messages::Message.define_error :NoSuchNick       , "401" , :nick, "No such nick/channel"
IRCParser::Messages::Message.define_error :NoSuchServer     , "402" , :server, "No such server"
IRCParser::Messages::Message.define_error :NoSuchChannel    , "403" , :channel, "No such channel"
IRCParser::Messages::Message.define_error :CannotSendToChan , "404" , :channel, "Cannot send to channel"
IRCParser::Messages::Message.define_error :TooManyChannels  , "405" , :channel, "You have joined too many channels"
IRCParser::Messages::Message.define_error :WasNoSuchNick    , "406" , :nick, "There was no such nickname"
IRCParser::Messages::Message.define_error :TooManyTargets   , "407" , :target, "Duplicate recipients. No message delivered"
IRCParser::Messages::Message.define_error :NoOrigin         , "409" , "No origin specified"

IRCParser::Messages::Message.define_error :NoRecipient      , "411" , "No recipient given (", :command, ")" do
  def initialize_params(vals)
    self.command = ( vals.to_s =~ /\(([^\)]+)\)/ && $1 )
  end

  def to_str
    "#{numeric} :No recipient given (#{command})\r\n"
  end
  alias_method :to_s, :to_str
end

IRCParser::Messages::Message.define_error :NoTextToSend     , "412" , "No text to send"
IRCParser::Messages::Message.define_error :NoTopLevel       , "413" , :mask, "No toplevel domain specified"
IRCParser::Messages::Message.define_error :WildTopLevel     , "414" , :mask, "Wildcard in toplevel domain"

IRCParser::Messages::Message.define_error :UnknownCommand   , "421" , :command, "Unknown command"
IRCParser::Messages::Message.define_error :NoMotd           , "422" , "MOTD File is missing"
IRCParser::Messages::Message.define_error :NoAdminInfo      , "423" , :server, "No administrative info available"

IRCParser::Messages::Message.define_error :FileError        , "424" , "File error doing", :file_op, "on", :file do
  def initialize_params(vals)
    self.file_op, self.file = $1, $2 if vals.join(" ") =~ /^File error doing\s+([^ ]+)\s+on\s+([^ ]+)/
  end

  def to_str
    "#{numeric} :File error doing #{file_op} on #{file}\r\n"
  end
  alias_method :to_s, :to_str
end

IRCParser::Messages::Message.define_error :NoNickNameGiven  , "431" , "No nickname given"
IRCParser::Messages::Message.define_error :ErroneusNickName , "432" , :nick, "Erroneus nickname"

IRCParser::Messages::Message.define_error :NickNameInUse    , '433' , :nick, "Nickname is already in use"
IRCParser::Messages::Message.define_error :NickCollision    , '436' , :nick, "Nickname collision KILL"
IRCParser::Messages::Message.define_error :UserNotInChannel , '441' , :nick, :channel, "They aren't on that channel"
IRCParser::Messages::Message.define_error :NotOnChannel     , '442' , :channel, "You're not on that channel"
IRCParser::Messages::Message.define_error :UserOnChannel    , '443' , :user, :channel, "is already on channel"
IRCParser::Messages::Message.define_error :NoLogin          , '444' , :user, "User not logged in"
IRCParser::Messages::Message.define_error :SummonDisabled   , '445' , "SUMMON has been disabled"
IRCParser::Messages::Message.define_error :UsersDisabled    , '446' , "USERS has been disabled"
IRCParser::Messages::Message.define_error :NotRegistered    , '451' , "You have not registered"
IRCParser::Messages::Message.define_error :NeedMoreParams   , '461' , :command, "Not enough parameters"
IRCParser::Messages::Message.define_error :AlreadyRegistred , '462' , "You may not reregister"
IRCParser::Messages::Message.define_error :NoPermForHost    , '463' , "Your host isn't among the privileged"
IRCParser::Messages::Message.define_error :PasswdMismatch   , '464' , "Password incorrect"
IRCParser::Messages::Message.define_error :YouReBannedCreep , '465' , "You are banned from this server"
IRCParser::Messages::Message.define_error :KeySet           , '467' , :channel, "Channel key already set"
IRCParser::Messages::Message.define_error :ChannelIsFull    , '471' , :channel, "Cannot join channel (+l)"
IRCParser::Messages::Message.define_error :UnknownMode      , '472' , :char, "is unknown mode char to me"
IRCParser::Messages::Message.define_error :InviteOnLYChan   , '473' , :channel, "Cannot join channel (+i)"
IRCParser::Messages::Message.define_error :BannedFromChan   , '474' , :channel, "Cannot join channel (+b)"
IRCParser::Messages::Message.define_error :BadChannelKey    , '475' , :channel, "Cannot join channel (+k)"
IRCParser::Messages::Message.define_error :NoPrivileges     , '481' , "Permission Denied- You're not an IRC operator"
IRCParser::Messages::Message.define_error :ChanOPrivsNeeded , '482' , :channel, "You're not channel operator"
IRCParser::Messages::Message.define_error :CantKillServer   , '483' , "You cant kill a server!"
IRCParser::Messages::Message.define_error :NoOperHost       , '491' , "No O-lines for your host"
IRCParser::Messages::Message.define_error :UModeUnknownFlag , '501' , "Unknown MODE flag"
IRCParser::Messages::Message.define_error :UsersDontMatch   , '502' , "Cant change mode for other users"

# Not Used / Reserved ( http://tools.ietf.org/html/rfc1459#section-6.3
# IRCParser::Messages::Message.define_error :YouWillBeBanned
# IRCParser::Messages::Message.define_error :BadChanMask
# IRCParser::Messages::Message.define_error :NoServiceHost
