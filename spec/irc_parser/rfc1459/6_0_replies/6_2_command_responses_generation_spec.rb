require 'spec_helper'

describe IRCParser, "command responses" do

  # Dummy reply number. Not used.
  it_parses "300" do |message|
  end

  # Reply format used by USERHOST to list replies to the query list.  The reply
  # string is composed as follows:
  #
  # <reply> ::= <nick>['*'] '=' <'+'|'-'><hostname>
  #
  # The '*' indicates whether the client has registered as
  # an Operator.  The '-' or '+' characters represent whether the client has
  # set an AWAY message or not respectively.
  it_parses "302 :user * = + host" do |message|
    message.nicks_and_hosts.should ==  "user * = + host"
  end

  # Reply format used by ISON to list replies to the query list.
  it_parses "303 :tony motola" do |message|
    message.nicks.should ==  ["tony", "motola"]
  end

  # These replies are used with the AWAY command (if allowed).  AWAY is sent to
  # any client sending a PRIVMSG to a client which is away.  AWAY is only sent
  # by the server to which the client is connected. Replies UNAWAY and NOWAWAY
  # are sent when the client removes and sets an AWAY message.
  it_parses "301 nick :away message" do |message|
    message.nick.should ==  "nick"
    message.message.should ==  "away message"
  end

  it_parses "305 :You are no longer marked as being away" do |message|
  end

  it_parses "306 :You have been marked as being away" do |message|
  end

  # Replies 311 - 313, 317 - 319 are all replies generated in response to a
  # WHOIS message.  Given that there are enough parameters present, the
  # answering server must either formulate a reply out of the above numerics
  # (if the query nick is found) or return an error reply.  The '*' in
  # WHOISUSER is there as the literal character and not as a wild card.  For
  # each reply set, only WHOISCHANNELS may appear more than once (for long
  # lists of channel names). The '@' and '+' characters next to the channel
  # name indicate whether a client is a channel operator or has been granted
  # permission to speak on a moderated channel.  The ENDOFWHOIS reply is used
  # to mark the end of processing a WHOIS message.
  it_parses "311 nick user host 192.168.0.1 :real name" do |message|
    message.nick.should == "nick"
    message.user.should == "user"
    message.host.should == "host"
    message.ip.should   == "192.168.0.1"
    message.real_name.should ==  "real name"
  end

  it_parses "312 nick user server :server info" do |message|
    message.nick.should   == "nick"
    message.user.should   == "user"
    message.server.should == "server"
    message.info.should   == "server info"
  end

  it_parses "313 nick user :is an IRC operator" do |message|
    message.nick.should == "nick"
    message.user.should == "user"
  end

  it_parses "317 nick user 10 :seconds idle" do |message|
    message.nick.should ==  "nick"
    message.seconds.should ==  "10"
  end

  it_parses "318 nick :End of /WHOIS list" do |message|
    message.nick.should ==  "nick"
  end

  # {[@|+]<channel><space>}
  it_parses "319 nick user :@channel1 +channel2 #channel3" do |message|
    message.nick.should ==  "nick"
    message.channels.should ==  %w|@channel1 +channel2 #channel3|
  end

  # When replying to a WHOWAS message, a server must use the replies
  # WHOWASUSER, WHOISSERVER or ERR_WASNOSUCHNICK for each nickname in the
  # presented list.  At the end of all reply batches, there must be ENDOFWHOWAS
  # (even if there was only one reply and it was an error).
  it_parses "314 nick user host * :real name" do |message|
    message.nick.should ==  "nick"
    message.user.should ==  "user"
    message.host.should ==  "host"
    message.real_name.should ==  "real name"
  end

  it_parses "369 nick :End of WHOWAS" do |message|
    message.nick.should ==  "nick"
  end

  # Replies LISTSTART, LIST, LISTEND mark the start, actual replies with data
  # and end of the server's response to a LIST command.  If there are no
  # channels available to return, only the start and end reply must be sent.
  it_parses "321 Channel :Users  Name" do |message|
  end

  it_parses "322 emmanuel #channel 12 :some topic" do |message|
    message.nick.should == "emmanuel"
    message.channel.should ==  "#channel"
    message.visible.should ==  "12"
    message.topic.should ==  "some topic"
  end

  it_parses "323 :End of /LIST" do |message|
  end

  it_parses "324 #channel o params" do |message|
    message.channel.should ==  "#channel"
    message.mode.should ==  "o"
    message.mode_params.should ==  "params"
  end

  # When sending a TOPIC message to determine the channel topic, one of two
  # replies is sent.  If the topic is set, TOPIC is sent back else NOTOPIC.
  it_parses "331 #channel :No topic is set" do |message|
    message.channel.should ==  "#channel"
  end

  it_parses "332 emmanuel #channel :the topic" do |message|
    message.nick.should == "emmanuel"
    message.channel.should ==  "#channel"
    message.topic.should ==  "the topic"
  end

  # Returned by the server to indicate that the attempted INVITE message was
  # successful and is being passed onto the end client.
  it_parses "341 #channel nick" do |message|
    message.channel.should ==  "#channel"
    message.nick.should ==  "nick"
  end

  # Returned by a server answering a SUMMON message to indicate that it is
  # summoning that user.
  it_parses "342 user :Summoning user to IRC" do |message|
    message.user.should ==  "user"
  end

  # Reply by the server showing its version details. The <version> is the
  # version of the software being used (including any patchlevel revisions) and
  # the <debuglevel> is used to indicate if the server is running in "debug
  # mode".  The "comments" field may contain any comments about the version or
  # further version details.
  it_parses "351 version.debuglevel server :the comments" do |message|
    message.version.should ==  "version.debuglevel"
    message.server.should ==  "server"
    message.comments.should ==  "the comments"
  end

  # The WHOREPLY and ENDOFWHO pair are used to answer a WHO message.  The
  # WHOREPLY is only sent if there is an appropriate match to the WHO query.
  # If there is a list of parameters supplied with a WHO message, a ENDOFWHO
  # must be sent after processing each list item with <name> being the item.
  it_parses "352 emmanuel #channel user host server nick H*@ :10 John B. Jovi" do |message| # <H|G>[*][@|+]
    message.channel.should ==  "#channel"
    message.user.should ==  "user"
    message.host.should ==  "host"
    message.server.should ==  "server"
    message.nick.should ==  "nick"
    message.flags.should ==  "H*@"
    message.hopcount.should ==  "10"
    message.real_name.should ==  "John B. Jovi"
  end

  it_parses "315 name :End of /WHO list" do |message|
    message.pattern.should ==  "name"
  end

  # To reply to a NAMES message, a reply pair consisting of NAMREPLY and
  # ENDOFNAMES is sent by the server back to the client.  If there is no
  # channel found as in the query, then only ENDOFNAMES is returned.  The
  # exception to this is when a NAMES message is sent with no parameters and
  # all visible channels and contents are sent back in a series of NAMEREPLY
  # messages with a ENDOFNAMES to mark the end.
  it_parses "353 = #channel :@nick1 +nick2 nick3" do |message|
    message.channel.should ==  "#channel"
    message.nicks.should ==  %w|@nick1 +nick2 nick3|
  end

  it_parses "366 #channel :End of /NAMES list" do |message|
    message.channel.should ==  "#channel"
  end

  # In replying to the LINKS message, a server must send replies back using the
  # LINKS numeric and mark the end of the list using an ENDOFLINKS reply.
  it_parses "364 mask server.com :10 server info" do |message|
    message.mask.should ==  "mask"
    message.server.should ==  "server.com"
    message.hopcount.should ==  "10"
    message.server_info.should ==  "server info"
  end

  it_parses "365 mask :End of /LINKS list" do |message|
    message.mask.should ==  "mask"
  end

  # When listing the active 'bans' for a given channel, a server is required to
  # send the list back using the BANLIST and ENDOFBANLIST messages.  A separate
  # BANLIST is sent for each active banid.  After the banids have been listed
  # (or if none present) a ENDOFBANLIST must be sent.
  it_parses "367 @channel banid" do |message|
    message.channel.should ==  "@channel"
    message.ban_id.should ==  "banid"
  end

  it_parses "368 &channel :End of channel ban list" do |message|
    message.channel.should ==  "&channel"
  end

  # A server responding to an INFO message is required to send all its 'info'
  # in a series of INFO messages with a ENDOFINFO reply to indicate the end of
  # the replies.
  it_parses "371 :Some Message" do |message|
    message.info.should ==  "Some Message"
  end

  it_parses "374 :End of /INFO list" do |message|
  end

  # When responding to the MOTD message and the MOTD file is found, the file is
  # displayed line by line, with each line no longer than 80 characters, using
  # MOTD format replies.  These should be surrounded by a MOTDSTART (before the
  # MOTDs) and an ENDOFMOTD (after).
  it_parses "375 :- pepito.com Message of the day -" do |message|
    message.server.should ==  "pepito.com"
  end

  it_parses "372 :- This is the very cool motd" do |message|
    message.motd.should ==  "This is the very cool motd"
  end

  it_parses "376 :End of /MOTD command" do |message|
  end

  # YOUREOPER is sent back to a client which has just successfully issued an
  # OPER message and gained operator status.
  it_parses "381 :You are now an IRC operator" do |message|
  end

  # If the REHASH option is used and an operator sends a REHASH message, an
  # REHASHING is sent back to the operator.
  it_parses "382 config.sys :Rehashing" do |message|
    message.config_file.should ==  "config.sys"
  end

  # When replying to the TIME message, a server must send the reply using the
  # TIME format above.  The string showing
  # the time need only contain the correct day and time there.  There is no
  # further requirement for the time string.
  it_parses "391 server.com :10:10pm" do |message|
    message.server.should ==  "server.com"
    message.local_time.should ==  "10:10pm"
  end

  # If the USERS message is handled by a server, the replies it_generates
  # USERSTART, USERS, ENDOFUSERS and it_generates
  # NOUSERS are used.  USERSSTART must be sent first, following by
  # either a sequence of USERS or a single NOUSER.
  # Following this is ENDOFUSERS.
  it_parses "392 :UserID   Terminal  Host" do |message|
  end

  it_parses "393 :012344567 012345678 01234567" do |message|
    message.users.should ==  "012344567 012345678 01234567"
  end

  it_parses "394 :End of users" do |message|
  end

  it_parses "395 :Nobody logged in" do |message|
  end

  # The TRACE* are all returned by the server in response to the
  # TRACE message.  How many are returned is dependent on the the TRACE message
  # and whether it was sent by an operator or not.  There is no predefined
  # order for which occurs first. Replies TRACEUNKNOWN,
  # TRACECONNECTING and TRACEHANDSHAKE are all used
  # for connections which have not been fully established and are either
  # unknown, still attempting to connect or in the process of completing the
  # 'server handshake'. TRACELINK is sent by any server which
  # handles a TRACE message and has to pass it on to another server.  The list
  # of TRACELINKs sent in response to a TRACE command traversing
  # the IRC network should reflect the actual connectivity of the servers
  # themselves along that path. TRACENEWTYPE is to be used for any
  # connection which does not fit in the other categories but is being
  # displayed anyway.
  it_parses "200 Link 1.10 destination.com next_server.net" do |message|
    message.version.should ==  "1.10"
    message.destination.should ==  "destination.com"
    message.next_server.should ==  "next_server.net"
  end

  it_parses "201 Try. class server" do |message|
    message.klass.should ==  "class"
    message.server.should ==  "server"
  end

  it_parses "202 H.S. class server" do |message|
    message.klass.should ==  "class"
    message.server.should ==  "server"
  end

  it_parses "203 ???? class 10.2.10.20" do |message|
    message.klass.should ==  "class"
    message.ip_address.should ==  "10.2.10.20"
  end

  it_parses "204 Oper class nick" do |message|
    message.klass.should ==  "class"
    message.nick.should ==  "nick"
  end

  it_parses "205 User class nick" do |message|
    message.klass.should ==  "class"
    message.nick.should ==  "nick"
  end

  it_parses "206 Serv class 10S 20C server nick!user@host" do |message|
    message.klass="class"
    message.intS="10S"
    message.intC="20C"
    message.server="server"
    message.identity="nick!user@host"""
  end

  it_parses "208 newtype 0 client_name" do |message|
    message.new_type.should ==  "newtype"
    message.client_name.should ==  "client_name"
  end

  it_parses "261 File logfile.log 2000" do |message|
    message.logfile.should ==  "logfile.log"
    message.debug_level.should ==  "2000"
  end

  # To answer a query about a client's own mode, UMODEIS is sent back.
  it_parses "211 linkname sendq 123 2048 456 1024 100" do |message|
    message.linkname= "linkname"
    message.sendq= "sendq"
    message.sent_messages= "123"
    message.sent_bytes= "2048"
    message.received_messages= "456"
    message.received_bytes= "1024"
    message.time_open= "100"
  end

  it_parses "212 command 10" do |message|
    message.command.should ==  "command"
    message.count.should ==  "10"
  end

  it_parses "213 C host * name 1232 class" do |message|
    message.host.should ==  "host"
    message.name_param.should ==  "name"
    message.port.should ==  "1232"
    message.klass.should ==  "class"
  end

  it_parses "214 N host * name 1232 class" do |message|
    message.host.should ==  "host"
    message.name_param.should ==  "name"
    message.port.should ==  "1232"
    message.klass.should ==  "class"
  end

  it_parses "215 I host1 * host2 1232 class" do |message|
    message.host.should ==  "host1"
    message.second_host.should ==  "host2"
    message.port.should ==  "1232"
    message.klass.should ==  "class"
  end

  it_parses "216 K host * username 1232 class" do |message|
    message.host.should ==  "host"
    message.username.should ==  "username"
    message.port.should ==  "1232"
    message.klass.should ==  "class"
  end

  it_parses "218 Y class 10 20 30" do |message|
    message.klass.should ==  "class"
    message.ping_frequency.should == "10"
    message.connect_frequency.should ==  "20"
    message.max_sendq.should ==  "30"
  end

  it_parses "219 L :End of /STATS report" do |message|
    message.stats_letter= "L"
  end

  it_parses "241 L hostmask * servername.com 20" do |message|
    message.host_mask.should ==  "hostmask"
    message.server_name.should ==  "servername.com"
    message.max_depth.should == "20"
  end

  it_parses "242 :Server Up 20 days 10:30:30" do |message|
    message.days.should ==  "20"
    message.time.should ==  "10:30:30"
  end

  it_parses "243 O hostmask * name" do |message|
    message.host_mask.should ==  "hostmask"
    message.name_param.should ==  "name"
  end

  it_parses "244 H hostmask * servername" do |message|
    message.host_mask.should ==  "hostmask"
    message.server_name.should ==  "servername"
  end

  it_parses ":server 221 Emmanuel +i" do |message|
    message.prefix.should == "server"
    message.nick.should ==  "Emmanuel"
    message.flags.should ==  "+i"
  end

  # In processing an LUSERS message, the server sends a set of replies from
  # LUSERCLIENT, LUSEROP, USERUNKNOWN, it_generates
  # LUSERCHANNELS and LUSERME.  When replying, a server must send
  # back LUSERCLIENT and LUSERME.  The other replies are only sent
  # back if a non-zero count is found for them.
  it_parses "251 :There are 10 users and 20 invisible on 30 servers" do |message|
    message.users_count.should == "10"
    message.invisible_count.should == "20"
    message.servers.should == "30"
  end

  it_parses "252 10 :operator(s) online" do |message|
    message.operator_count.should == "10"
  end

  it_parses "253 7 :unknown connection(s)" do |message|
    message.connections.should == "7"
  end

  it_parses "254 3 :channels formed" do |message|
    message.channels_count.should == "3"
  end

  it_parses "255 :I have 8 clients and 3 servers" do |message|
    message.clients_count.should == "8"
    message.servers_count.should == "3"
  end

  # When replying to an ADMIN message, a server is expected to use replies
  # RLP_ADMINME through to ADMINEMAIL and provide a text message with each.
  # For ADMINLOC1 a description of what city, state and country the server is
  # in is expected, followed by details of the university and department
  # (ADMINLOC2) and finally the administrative contact for the server (an email
  # address here is required) in ADMINEMAIL.
  it_parses "256 server.com :Administrative info" do |message|
    message.server.should ==  "server.com"
  end

  it_parses "257 :info" do |message|
    message.info.should ==  "info"
  end

  it_parses "258 :info" do |message|
    message.info.should ==  "info"
  end

  it_parses "259 :info" do |message|
    message.info.should ==  "info"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::RplNone, "300" do |message|
  end

  it_generates IRCParser::Messages::RplUserHost, "302 :user * = + host" do |message|
    message.nicks_and_hosts = "user * = + host"
  end


  it_generates IRCParser::Messages::RplIsOn, "303 :tony motola" do |message|
    message.nicks = ["tony", "motola"]
  end

  it_generates IRCParser::Messages::RplAway, "301 nick :away message" do |message|
    message.nick = "nick"
    message.message = "away message"
  end

  it_generates IRCParser::Messages::RplUnAway, "305 :You are no longer marked as being away" do |message|
  end

  it_generates IRCParser::Messages::RplNowAway, "306 :You have been marked as being away" do |message|
  end

  it_generates IRCParser::Messages::RplWhoIsUser, "311 nick user host * :real name" do |message|
    message.nick = "nick"
    message.user = "user"
    message.host = "host"
    message.real_name = "real name"
  end

  it_generates IRCParser::Messages::RplWhoIsServer, "312 nick user server :server info" do |message|
    message.nick = "nick"
    message.user = "user"
    message.server = "server"
    message.info = "server info"
  end

  it_generates IRCParser::Messages::RplWhoIsOperator, "313 nick user :is an IRC operator" do |message|
    message.user = "user"
    message.nick = "nick"
  end

  it_generates IRCParser::Messages::RplWhoIsIdle, "317 nick user 10 :seconds idle" do |message|
    message.nick = "nick"
    message.user = "user"
    message.seconds = "10"
  end

  it_generates IRCParser::Messages::RplEndOfWhoIs, "318 nick :End of /WHOIS list" do |message|
    message.nick = "nick"
  end

  it_generates IRCParser::Messages::RplWhoIsChannels, "319 nick user :@channel1 +channel2 #channel3" do |message|
    message.nick = "nick"
    message.user = "user"
    message.channels = %w|@channel1 +channel2 #channel3|
  end

  it_generates IRCParser::Messages::RplWhoWasUser, "314 nick user host * :real name" do |message|
    message.nick = "nick"
    message.user = "user"
    message.host = "host"
    message.real_name = "real name"
  end

  it_generates IRCParser::Messages::RplEndOfWhoWas, "369 nick :End of WHOWAS" do |message|
    message.nick = "nick"
  end

  it_generates IRCParser::Messages::RplListStart, "321 Channel :Users  Name" do |message|
  end

  it_generates IRCParser::Messages::RplList, "322 emmanuel #channel 12 :some topic" do |message|
    message.nick= "emmanuel"
    message.channel = "#channel"
    message.visible = "12"
    message.topic = "some topic"
  end

  it_generates IRCParser::Messages::RplListEnd, "323 :End of /LIST" do |message|
  end

  it_generates IRCParser::Messages::RplChannelModeIs, "324 #channel o params" do |message|
    message.channel = "#channel"
    message.mode = "o"
    message.mode_params = "params"
  end

  it_generates IRCParser::Messages::RplNoTopic, "331 #channel :No topic is set" do |message|
    message.channel = "#channel"
  end

  it_generates IRCParser::Messages::RplTopic, "332 emmanuel #channel :the topic" do |message|
    message.nick = "emmanuel"
    message.channel = "#channel"
    message.topic = "the topic"
  end

  it_generates IRCParser::Messages::RplInviting, "341 #channel nick" do |message|
    message.channel = "#channel"
    message.nick = "nick"
  end

  it_generates IRCParser::Messages::RplSummoning, "342 user :Summoning user to IRC" do |message|
    message.user = "user"
  end

  it_generates IRCParser::Messages::RplVersion, "351 version.debuglevel server :the comments" do |message|
    message.version = "version.debuglevel"
    message.server = "server"
    message.comments = "the comments"
  end

  it_generates IRCParser::Messages::RplWhoReply, "352 nick #channel user host server nick H*@ :10 John B. Jovi" do |message| # <H|G>[*][@|+]
    message.channel = "#channel"
    message.user = "user"
    message.host = "host"
    message.server = "server"
    message.nick = "nick"
    message.flags = "H*@"
    message.here! true
    message.ircop! true
    message.opped! true
    message.hopcount = 10
    message.real_name = "John B. Jovi"
  end

  it_generates IRCParser::Messages::RplEndOfWho, "315 pattern :End of /WHO list" do |message|
    message.pattern = "pattern"
  end

  it_generates IRCParser::Messages::RplNamReply, "353 = #channel :@nick1 +nick2 nick3" do |message|
    message.channel = "#channel"
    message.nicks = %w|@nick1 +nick2 nick3|
  end

  it_generates IRCParser::Messages::RplEndOfNames, "366 #channel :End of /NAMES list" do |message|
    message.channel = "#channel"
  end

  it_generates IRCParser::Messages::RplLinks, "364 mask server.com :10 server info" do |message|
    message.mask = "mask"
    message.server = "server.com"
    message.hopcount = 10
    message.server_info = "server info"
  end

  it_generates IRCParser::Messages::RplEndOfLinks, "365 mask :End of /LINKS list" do |message|
    message.mask = "mask"
  end

  it_generates IRCParser::Messages::RplBanList, "367 @channel banid" do |message|
    message.channel = "@channel"
    message.ban_id = "banid"
  end

  it_generates IRCParser::Messages::RplEndOfBanList, "368 &channel :End of channel ban list" do |message|
    message.channel = "&channel"
  end

  it_generates IRCParser::Messages::RplInfo, "371 :Some Message" do |message|
    message.info = "Some Message"
  end

  it_generates IRCParser::Messages::RplEndOfInfo, "374 :End of /INFO list" do |message|
  end

  it_generates IRCParser::Messages::RplMotdStart, "375 :- pepito.com Message of the day -" do |message|
    message.server = "pepito.com"
  end

  it_generates IRCParser::Messages::RplMotd, "372 :- This is the very cool motd" do |message|
    message.motd = "This is the very cool motd"
  end

  it_generates IRCParser::Messages::RplEndOfMotd, "376 :End of /MOTD command" do |message|
  end

  it_generates IRCParser::Messages::RplYouReOper, "381 :You are now an IRC operator" do |message|
  end

  it_generates IRCParser::Messages::RplRehashing, "382 config.sys :Rehashing" do |message|
    message.config_file = "config.sys"
  end

  it_generates IRCParser::Messages::RplTime, "391 server.com :10:10pm" do |message|
    message.server = "server.com"
    message.local_time = "10:10pm"
  end

  it_generates IRCParser::Messages::RplUsersStart, "392 :UserID   Terminal  Host" do |message|
  end

  it_generates IRCParser::Messages::RplUsers, "393 :012344567 012345678 01234567" do |message|
    message.users = "012344567 012345678 01234567"
  end

  it_generates IRCParser::Messages::RplEndOfUsers, "394 :End of users" do |message|
  end

  it_generates IRCParser::Messages::RplNoUsers, "395 :Nobody logged in" do |message|
  end

  it_generates IRCParser::Messages::RplTraceLink, "200 Link 1.10 destination.com next_server.net" do |message|
    message.version = "1.10"
    message.destination = "destination.com"
    message.next_server = "next_server.net"
  end

  it_generates IRCParser::Messages::RplTraceConnecting, "201 Try. class server" do |message|
    message.klass = "class"
    message.server = "server"
  end

  it_generates IRCParser::Messages::RplTraceHandshake, "202 H.S. class server" do |message|
    message.klass = "class"
    message.server = "server"
  end

  it_generates IRCParser::Messages::RplTraceUnknown, "203 ???? class 10.2.10.20" do |message|
    message.klass = "class"
    message.ip_address = "10.2.10.20"
  end

  it_generates IRCParser::Messages::RplTraceOperator, "204 Oper class nick" do |message|
    message.klass = "class"
    message.nick = "nick"
  end

  it_generates IRCParser::Messages::RplTraceUser, "205 User class nick" do |message|
    message.klass = "class"
    message.nick = "nick"
  end

  it_generates IRCParser::Messages::RplTraceServer, "206 Serv class 10S 20C server nick!user@host" do |message|
    message.klass    = "class"
    message.intS     = "10S"
    message.intC     = "20C"
    message.server   = "server"
    message.identity = "nick!user@host"
  end

  it_generates IRCParser::Messages::RplTraceNewType, "208 newtype 0 client_name" do |message|
    message.new_type = "newtype"
    message.client_name = "client_name"
  end

  it_generates IRCParser::Messages::RplTraceLog, "261 File logfile.log 2000" do |message|
    message.logfile = "logfile.log"
    message.debug_level = "2000"
  end

  it_generates IRCParser::Messages::RplStatsLinkInfo, "211 linkname sendq 123 2048 456 1024 100" do |message|
    message.linkname= "linkname"
    message.sendq= "sendq"
    message.sent_messages= 123
    message.sent_bytes= 2048
    message.received_messages= 456
    message.received_bytes= 1024
    message.time_open= 100
  end

  it_generates IRCParser::Messages::RplStatsCommands, "212 command 10" do |message|
    message.command = "command"
    message.count = 10
  end

  it_generates IRCParser::Messages::RplStatsCLine, "213 C host * name 1232 class" do |message|
    message.host = "host"
    message.name_param = "name"
    message.port = "1232"
    message.klass = "class"
  end

  it_generates IRCParser::Messages::RplStatsNLine, "214 N host * name 1232 class" do |message|
    message.host = "host"
    message.name_param = "name"
    message.port = "1232"
    message.klass = "class"
  end

  it_generates IRCParser::Messages::RplStatsILine, "215 I host1 * host2 1232 class" do |message|
    message.host = "host1"
    message.second_host = "host2"
    message.port = "1232"
    message.klass = "class"
  end

  it_generates IRCParser::Messages::RplStatsKLine, "216 K host * username 1232 class" do |message|
    message.host = "host"
    message.username = "username"
    message.port = "1232"
    message.klass = "class"
  end

  it_generates IRCParser::Messages::RplStatsYLine, "218 Y class 10 20 30" do |message|
    message.klass = "class"
    message.ping_frequency = 10
    message.connect_frequency = 20
    message.max_sendq = 30
  end

  it_generates IRCParser::Messages::RplEndOfStats, "219 L :End of /STATS report" do |message|
    message.stats_letter= "L"
  end

  it_generates IRCParser::Messages::RplStatsLLine, "241 L hostmask * servername.com 20" do |message|
    message.host_mask = "hostmask"
    message.server_name = "servername.com"
    message.max_depth = 20
  end

  it_generates IRCParser::Messages::RplStatsUptime, "242 :Server Up 20 days 10:30:30" do |message|
    message.days = "20"
    message.time = "10:30:30"
  end

  it_generates IRCParser::Messages::RplStatsOLine, "243 O hostmask * name" do |message|
    message.host_mask = "hostmask"
    message.name_param = "name"
  end

  it_generates IRCParser::Messages::RplStatsHLine, "244 H hostmask * servername" do |message|
    message.host_mask = "hostmask"
    message.server_name = "servername"
  end

  it_generates IRCParser::Messages::RplUModeIs, ":server 221 Emmanuel +i" do |message|
    message.prefix = "server"
    message.nick   = "Emmanuel"
    message.flags  = "+i"
  end

  it_generates IRCParser::Messages::RplLUserClient, "251 :There are 10 users and 20 invisible on 30 servers" do |message|
    message.users_count = 10
    message.invisible_count = 20
    message.servers = 30
  end

  it_generates IRCParser::Messages::RplLUserOp, "252 10 :operator(s) online" do |message|
    message.operator_count = 10
  end

  it_generates IRCParser::Messages::RplLUserUnknown, "253 7 :unknown connection(s)" do |message|
    message.connections = 7
  end

  it_generates IRCParser::Messages::RplLUserChannels, "254 3 :channels formed" do |message|
    message.channels_count = 3
  end

  it_generates IRCParser::Messages::RplLUserMe, "255 :I have 8 clients and 3 servers" do |message|
    message.clients_count = 8
    message.servers_count = 3
  end

  it_generates IRCParser::Messages::RplAdminMe, "256 server.com :Administrative info" do |message|
    message.server = "server.com"
  end

  it_generates IRCParser::Messages::RplAdminLoc1, "257 :info" do |message|
    message.info = "info"
  end

  it_generates IRCParser::Messages::RplAdminLoc2, "258 :info" do |message|
    message.info = "info"
  end

  it_generates IRCParser::Messages::RplAdminEmail, "259 :info" do |message|
    message.info = "info"
  end

end
