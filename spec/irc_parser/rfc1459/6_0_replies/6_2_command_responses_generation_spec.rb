require 'spec_helper'

describe IRCParser, "command responses" do

  # Dummy reply number. Not used.
  it_parses "300 Wiz" do |msg|
    msg.nick.should == "Wiz"
  end

  # Reply format used by USERHOST to list replies to the query list.  The reply
  # string is composed as follows:
  #
  # <reply> ::= <nick>['*'] '=' <'+'|'-'><hostname>
  #
  # The '*' indicates whether the client has registered as
  # an Operator.  The '-' or '+' characters represent whether the client has
  # set an AWAY msg or not respectively.
  it_parses "302 Wiz :user = +host" do |msg|
    msg.nick = "emmanuel"
    msg.nicks = "user"
    msg.host_with_sign = "+host"
  end

  # Reply format used by ISON to list replies to the query list.
  it_parses "303 Wiz :tony motola" do |msg|
    msg.nick.should == "Wiz"
    msg.nicks.should ==  ["tony", "motola"]
  end

  # These replies are used with the AWAY command (if allowed).  AWAY is sent to
  # any client sending a PRIVMSG to a client which is away.  AWAY is only sent
  # by the server to which the client is connected. Replies UNAWAY and NOWAWAY
  # are sent when the client removes and sets an AWAY msg.
  it_parses "301 Wiz nick :away message" do |msg|
    msg.nick.should ==  "Wiz"
    msg.away_nick.should == "nick"
    msg.message.should ==  "away message"
  end

  it_parses "305 Wiz :You are no longer marked as being away" do |msg|
    msg.nick = "Wiz"
  end

  it_parses "306 Wiz :You have been marked as being away" do |msg|
    msg.nick = "Wiz"
  end

  # Replies 311 - 313, 317 - 319 are all replies generated in response to a
  # WHOIS msg.  Given that there are enough parameters present, the
  # answering server must either formulate a reply out of the above numerics
  # (if the query nick is found) or return an error reply.  The '*' in
  # WHOISUSER is there as the literal character and not as a wild card.  For
  # each reply set, only WHOISCHANNELS may appear more than once (for long
  # lists of channel names). The '@' and '+' characters next to the channel
  # name indicate whether a client is a channel operator or has been granted
  # permission to speak on a moderated channel.  The ENDOFWHOIS reply is used
  # to mark the end of processing a WHOIS msg.
  it_parses "311 Wiz nick user 192.168.0.1 * :real name" do |msg|
    msg.nick.should == "Wiz"
    msg.user_nick.should == "nick"
    msg.user.should == "user"
    msg.ip.should   == "192.168.0.1"
    msg.realname.should ==  "real name"
  end

  it_parses "312 nick user server :server info" do |msg|
    msg.nick.should   == "nick"
    msg.user.should   == "user"
    msg.server.should == "server"
    msg.info.should   == "server info"
  end

  it_parses "313 nick user :is an IRC operator" do |msg|
    msg.nick.should == "nick"
    msg.user.should == "user"
  end

  it_parses "317 nick user 10 :seconds idle" do |msg|
    msg.nick.should ==  "nick"
    msg.seconds.should ==  "10"
  end

  it_parses "318 Wiz nick :End of /WHOIS list" do |msg|
    msg.nick.should ==  "Wiz"
    msg.user_nick.should ==  "nick"
  end

  # {[@|+]<channel><space>}
  it_parses "319 nick user :@channel1 +channel2 #channel3" do |msg|
    msg.nick.should ==  "nick"
    msg.channels.should ==  %w|@channel1 +channel2 #channel3|
  end

  # When replying to a WHOWAS msg, a server must use the replies
  # WHOWASUSER, WHOISSERVER or ERR_WASNOSUCHNICK for each nickname in the
  # presented list.  At the end of all reply batches, there must be ENDOFWHOWAS
  # (even if there was only one reply and it was an error).
  it_parses "314 nick user host * :real name" do |msg|
    msg.nick.should ==  "nick"
    msg.user.should ==  "user"
    msg.host.should ==  "host"
    msg.realname.should ==  "real name"
  end

  it_parses "369 nick :End of WHOWAS" do |msg|
    msg.nick.should ==  "nick"
  end

  # Replies LISTSTART, LIST, LISTEND mark the start, actual replies with data
  # and end of the server's response to a LIST command.  If there are no
  # channels available to return, only the start and end reply must be sent.
  it_parses "321 Channel :Users  Name" do |msg|
  end

  it_parses "322 emmanuel #channel 12 :some topic" do |msg|
    msg.nick.should == "emmanuel"
    msg.channel.should ==  "#channel"
    msg.visible.should ==  "12"
    msg.topic.should ==  "some topic"
  end

  it_parses "323 Wiz :End of /LIST" do |msg|
    msg.nick.should == "Wiz"
  end

  it_parses "324 Wiz #channel o params" do |msg|
    msg.nick.should == "Wiz"
    msg.channel.should ==  "#channel"
    msg.mode.should ==  "o"
  end

  # When sending a TOPIC msg to determine the channel topic, one of two
  # replies is sent.  If the topic is set, TOPIC is sent back else NOTOPIC.
  it_parses "331 Wiz #channel :No topic is set" do |msg|
    msg.nick.should == "Wiz"
    msg.channel.should ==  "#channel"
  end

  it_parses "332 emmanuel #channel :the topic" do |msg|
    msg.nick.should == "emmanuel"
    msg.channel.should ==  "#channel"
    msg.topic.should ==  "the topic"
  end

  # Returned by the server to indicate that the attempted INVITE msg was
  # successful and is being passed onto the end client.
  it_parses "341 Wiz #channel nick" do |msg|
    msg.nick.should == "Wiz"
    msg.channel.should ==  "#channel"
    msg.nick_inv.should ==  "nick"
  end

  # Returned by a server answering a SUMMON msg to indicate that it is
  # summoning that user.
  it_parses "342 Wiz user :Summoning user to IRC" do |msg|
    msg.nick = "Wiz"
    msg.user.should ==  "user"
  end

  # Reply by the server showing its version details. The <version> is the
  # version of the software being used (including any patchlevel revisions) and
  # the <debuglevel> is used to indicate if the server is running in "debug
  # mode".  The "comments" field may contain any comments about the version or
  # further version details.
  it_parses "351 Wiz version.debuglevel server :the comments" do |msg|
    msg.nick.should == "Wiz"
    msg.version.should ==  "version.debuglevel"
    msg.server.should ==  "server"
    msg.comments.should ==  "the comments"
  end

  # The WHOREPLY and ENDOFWHO pair are used to answer a WHO msg.  The
  # WHOREPLY is only sent if there is an appropriate match to the WHO query.
  # If there is a list of parameters supplied with a WHO msg, a ENDOFWHO
  # must be sent after processing each list item with <name> being the item.
  it_parses "352 Wiz #channel user host server nick H*@ :10 John B. Jovi" do |msg| # <H|G>[*][@|+]
    msg.nick.should == "Wiz"
    msg.channel.should ==  "#channel"
    msg.user.should ==  "user"
    msg.host.should ==  "host"
    msg.server.should ==  "server"
    msg.user_nick.should ==  "nick"
    msg.flags.should ==  "H*@"
    msg.hopcount.should ==  "10"
    msg.realname.should ==  "John B. Jovi"
  end

  it_parses "315 Wiz name :End of /WHO list" do |msg|
    msg.nick.should == "Wiz"
    msg.pattern.should == "name"
  end

  # To reply to a NAMES msg, a reply pair consisting of NAMREPLY and
  # ENDOFNAMES is sent by the server back to the client.  If there is no
  # channel found as in the query, then only ENDOFNAMES is returned.  The
  # exception to this is when a NAMES msg is sent with no parameters and
  # all visible channels and contents are sent back in a series of NAMEREPLY
  # msgs with a ENDOFNAMES to mark the end.
  it_parses "353 Wiz #channel :@nick1 +nick2 nick3" do |msg|
    msg.channel.should ==  "#channel"
    msg.nicks_with_flags.should ==  %w|@nick1 +nick2 nick3|
  end

  it_parses "366 #channel :End of /NAMES list" do |msg|
    msg.channel.should ==  "#channel"
  end

  # In replying to the LINKS msg, a server must send replies back using the
  # LINKS numeric and mark the end of the list using an ENDOFLINKS reply.
  it_parses "364 Wiz mask server.com :10 server info" do |msg|
    msg.nick.should == "Wiz"
    msg.mask.should ==  "mask"
    msg.server.should ==  "server.com"
    msg.hopcount.should ==  "10"
    msg.server_info.should ==  "server info"
  end

  it_parses "365 Wiz mask :End of /LINKS list" do |msg|
    msg.nick = "Wiz"
    msg.mask.should ==  "mask"
  end

  # When listing the active 'bans' for a given channel, a server is required to
  # send the list back using the BANLIST and ENDOFBANLIST msgs.  A separate
  # BANLIST is sent for each active banid.  After the banids have been listed
  # (or if none present) a ENDOFBANLIST must be sent.
  it_parses "367 Wiz @channel banid" do |msg|
    msg.channel.should ==  "@channel"
    msg.ban_id.should ==  "banid"
  end

  it_parses "368 Wiz &channel :End of channel ban list" do |msg|
    msg.channel.should ==  "&channel"
  end

  # A server responding to an INFO msg is required to send all its 'info'
  # in a series of INFO msgs with a ENDOFINFO reply to indicate the end of
  # the replies.
  it_parses "371 Wiz :Some Message" do |msg|
    msg.info.should ==  "Some Message"
  end

  it_parses "374 Wiz :End of /INFO list" do |msg|
  end

  # When responding to the MOTD msg and the MOTD file is found, the file is
  # displayed line by line, with each line no longer than 80 characters, using
  # MOTD format replies.  These should be surrounded by a MOTDSTART (before the
  # MOTDs) and an ENDOFMOTD (after).
  it_parses "375 Wiz :- pepito.com Message of the day -" do |msg|
    msg.server.should ==  "pepito.com"
  end

  it_parses "372 Wiz :- This is the very cool motd" do |msg|
    msg.motd.should ==  "This is the very cool motd"
  end

  it_parses "376 Wiz :End of /MOTD command" do |msg|
  end

  # YOUREOPER is sent back to a client which has just successfully issued an
  # OPER msg and gained operator status.
  it_parses "381 Wiz :You are now an IRC operator" do |msg|
  end

  # If the REHASH option is used and an operator sends a REHASH msg, an
  # REHASHING is sent back to the operator.
  it_parses "382 Wiz config.sys :Rehashing" do |msg|
    msg.config_file.should ==  "config.sys"
  end

  # When replying to the TIME msg, a server must send the reply using the
  # TIME format above.  The string showing
  # the time need only contain the correct day and time there.  There is no
  # further requirement for the time string.
  it_parses "391 Wiz server.com :10:10pm" do |msg|
    msg.server.should ==  "server.com"
    msg.local_time.should ==  "10:10pm"
  end

  # If the USERS msg is handled by a server, the replies it_generates
  # USERSTART, USERS, ENDOFUSERS and it_generates
  # NOUSERS are used.  USERSSTART must be sent first, following by
  # either a sequence of USERS or a single NOUSER.
  # Following this is ENDOFUSERS.
  it_parses "392 Wiz :UserID   Terminal  Host" do |msg|
  end

  it_parses "393 Wiz :012344567 012345678 01234567" do |msg|
    msg.users.should ==  "012344567 012345678 01234567"
  end

  it_parses "394 Wiz :End of users" do |msg|
  end

  it_parses "395 Wiz :Nobody logged in" do |msg|
  end

  # The TRACE* are all returned by the server in response to the
  # TRACE msg.  How many are returned is dependent on the the TRACE message
  # and whether it was sent by an operator or not.  There is no predefined
  # order for which occurs first. Replies TRACEUNKNOWN,
  # TRACECONNECTING and TRACEHANDSHAKE are all used
  # for connections which have not been fully established and are either
  # unknown, still attempting to connect or in the process of completing the
  # 'server handshake'. TRACELINK is sent by any server which
  # handles a TRACE msg and has to pass it on to another server.  The list
  # of TRACELINKs sent in response to a TRACE command traversing
  # the IRC network should reflect the actual connectivity of the servers
  # themselves along that path. TRACENEWTYPE is to be used for any
  # connection which does not fit in the other categories but is being
  # displayed anyway.
  it_parses "200 Wiz Link 1.10 destination.com next_server.net" do |msg|
    msg.version.should ==  "1.10"
    msg.destination.should ==  "destination.com"
    msg.next_server.should ==  "next_server.net"
  end

  it_parses "201 Wiz Try. class server" do |msg|
    msg.klass.should ==  "class"
    msg.server.should ==  "server"
  end

  it_parses "202 Wiz H.S. class server" do |msg|
    msg.klass.should ==  "class"
    msg.server.should ==  "server"
  end

  it_parses "203 Wiz ???? class 10.2.10.20" do |msg|
    msg.klass.should ==  "class"
    msg.ip_address.should ==  "10.2.10.20"
  end

  it_parses "204 Wiz Oper class nick" do |msg|
    msg.nick.should ==  "Wiz"
    msg.klass.should ==  "class"
    msg.user_nick.should ==  "nick"
  end

  it_parses "205 Wiz User class nick" do |msg|
    msg.nick.should == "Wiz"
    msg.klass.should ==  "class"
    msg.user_nick.should ==  "nick"
  end

  it_parses "206 Wiz Serv class 10S 20C server nick!user@host" do |msg|
    msg.klass="class"
    msg.intS="10S"
    msg.intC="20C"
    msg.server="server"
    msg.identity="nick!user@host"""
  end

  it_parses "208 Wiz newtype 0 client_name" do |msg|
    msg.new_type.should ==  "newtype"
    msg.client_name.should ==  "client_name"
  end

  it_parses "261 Wiz File logfile.log 2000" do |msg|
    msg.logfile.should ==  "logfile.log"
    msg.debug_level.should ==  "2000"
  end

  # To answer a query about a client's own mode, UMODEIS is sent back.
  it_parses "211 Wiz linkname sendq 123 2048 456 1024 100" do |msg|
    msg.nick = "Wiz"
    msg.linkname= "linkname"
    msg.sendq= "sendq"
    msg.sent_messages= "123"
    msg.sent_bytes= "2048"
    msg.received_messages= "456"
    msg.received_bytes= "1024"
    msg.time_open= "100"
  end

  it_parses "212 Wiz command 10" do |msg|
    msg.command.should ==  "command"
    msg.count.should ==  "10"
  end

  it_parses "213 Wiz C host * name 1232 class" do |msg|
    msg.host.should ==  "host"
    msg.name_param.should ==  "name"
    msg.port.should ==  "1232"
    msg.klass.should ==  "class"
  end

  it_parses "214 Wiz N host * name 1232 class" do |msg|
    msg.host.should ==  "host"
    msg.name_param.should ==  "name"
    msg.port.should ==  "1232"
    msg.klass.should ==  "class"
  end

  it_parses "215 Wiz I host1 * host2 1232 class" do |msg|
    msg.host.should ==  "host1"
    msg.second_host.should ==  "host2"
    msg.port.should ==  "1232"
    msg.klass.should ==  "class"
  end

  it_parses "216 Wiz K host * username 1232 class" do |msg|
    msg.host.should ==  "host"
    msg.username.should ==  "username"
    msg.port.should ==  "1232"
    msg.klass.should ==  "class"
  end

  it_parses "218 Wiz Y class 10 20 30" do |msg|
    msg.klass.should ==  "class"
    msg.ping_frequency.should == "10"
    msg.connect_frequency.should ==  "20"
    msg.max_sendq.should ==  "30"
  end

  it_parses "219 Wiz L :End of /STATS report" do |msg|
    msg.stats_letter= "L"
  end

  it_parses "241 Wiz L hostmask * servername.com 20" do |msg|
    msg.host_mask.should ==  "hostmask"
    msg.server_name.should ==  "servername.com"
    msg.max_depth.should == "20"
  end

  it_parses "242 Wiz :Server Up 20 days 10:30:30" do |msg|
    msg.days.should ==  "20"
    msg.time.should ==  "10:30:30"
  end

  it_parses "243 Wiz O hostmask * name" do |msg|
    msg.host_mask.should ==  "hostmask"
    msg.name_param.should ==  "name"
  end

  it_parses "244 Wiz H hostmask * servername" do |msg|
    msg.host_mask.should ==  "hostmask"
    msg.server_name.should ==  "servername"
  end

  it_parses ":server 221 Wiz nick +i" do |msg|
    msg.prefix.should == "server"
    msg.nick.should ==  "Wiz"
    msg.user_nick.should ==  "nick"
    msg.flags.should ==  "+i"
  end

  # In processing an LUSERS msg, the server sends a set of replies from
  # LUSERCLIENT, LUSEROP, USERUNKNOWN, it_generates
  # LUSERCHANNELS and LUSERME.  When replying, a server must send
  # back LUSERCLIENT and LUSERME.  The other replies are only sent
  # back if a non-zero count is found for them.
  it_parses "251 Wiz :There are 10 users and 20 invisible on 30 servers" do |msg|
    msg.users_count.should == "10"
    msg.invisible_count.should == "20"
    msg.servers.should == "30"
  end

  it_parses "252 Wiz 10 :operator(s) online" do |msg|
    msg.operator_count.should == "10"
  end

  it_parses "253 Wiz 7 :unknown connection(s)" do |msg|
    msg.connections.should == "7"
  end

  it_parses "254 Wiz 3 :channels formed" do |msg|
    msg.channels_count.should == "3"
  end

  it_parses "255 Wiz :I have 8 clients and 3 servers" do |msg|
    msg.clients_count.should == "8"
    msg.servers_count.should == "3"
  end

  # When replying to an ADMIN msg, a server is expected to use replies
  # RLP_ADMINME through to ADMINEMAIL and provide a text msg with each.
  # For ADMINLOC1 a description of what city, state and country the server is
  # in is expected, followed by details of the university and department
  # (ADMINLOC2) and finally the administrative contact for the server (an email
  # address here is required) in ADMINEMAIL.
  it_parses "256 Wiz server.com :Administrative info" do |msg|
    msg.server.should ==  "server.com"
  end

  it_parses "257 Wiz :info" do |msg|
    msg.info.should ==  "info"
  end

  it_parses "258 Wiz :info" do |msg|
    msg.info.should ==  "info"
  end

  it_parses "259 Wiz :info" do |msg|
    msg.info.should ==  "info"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::RplNone, "300 Wiz" do |msg|
    msg.nick = "Wiz"
  end

  it_generates IRCParser::Messages::RplUserHost, "302 Wiz :user = +host" do |msg|
    msg.nick = "Wiz"
    msg.nicks = "user"
    msg.host_with_sign = "+host"
  end


  it_generates IRCParser::Messages::RplIsOn, "303 Wiz :tony motola" do |msg|
    msg.nick = "Wiz"
    msg.nicks = ["tony", "motola"]
  end

  it_generates IRCParser::Messages::RplAway, "301 Wiz nick :away message" do |msg|
    msg.nick = "Wiz"
    msg.away_nick = "nick"
    msg.message = "away message"
  end

  it_generates IRCParser::Messages::RplUnAway, "305 Wiz :You are no longer marked as being away" do |msg|
    msg.nick = "Wiz"
  end

  it_generates IRCParser::Messages::RplNowAway, "306 Wiz :You have been marked as being away" do |msg|
    msg.nick = "Wiz"
  end

  it_generates IRCParser::Messages::RplWhoIsUser, "311 Wiz nick user 192.192.192.192 * :real name" do |msg|
    msg.nick = "Wiz"
    msg.user_nick = "nick"
    msg.user = "user"
    msg.realname = "real name"
    msg.ip = "192.192.192.192"
  end

  it_generates IRCParser::Messages::RplWhoIsServer, "312 nick user server :server info" do |msg|
    msg.nick = "nick"
    msg.user = "user"
    msg.server = "server"
    msg.info = "server info"
  end

  it_generates IRCParser::Messages::RplWhoIsOperator, "313 nick user :is an IRC operator" do |msg|
    msg.user = "user"
    msg.nick = "nick"
  end

  it_generates IRCParser::Messages::RplWhoIsIdle, "317 nick user 10 :seconds idle" do |msg|
    msg.nick = "nick"
    msg.user = "user"
    msg.seconds = "10"
  end

  it_generates IRCParser::Messages::RplEndOfWhoIs, "318 Wiz nick :End of /WHOIS list" do |msg|
    msg.nick = "Wiz"
    msg.user_nick = "nick"
  end

  it_generates IRCParser::Messages::RplWhoIsChannels, "319 nick user :@channel1 +channel2 #channel3" do |msg|
    msg.nick = "nick"
    msg.user = "user"
    msg.channels = %w|@channel1 +channel2 #channel3|
  end

  it_generates IRCParser::Messages::RplWhoWasUser, "314 nick user host * :real name" do |msg|
    msg.nick = "nick"
    msg.user = "user"
    msg.host = "host"
    msg.realname = "real name"
  end

  it_generates IRCParser::Messages::RplEndOfWhoWas, "369 nick :End of WHOWAS" do |msg|
    msg.nick = "nick"
  end

  it_generates IRCParser::Messages::RplListStart, "321 Wiz Channel :Users  Name" do |msg|
    msg.nick = "Wiz"
  end

  it_generates IRCParser::Messages::RplList, "322 emmanuel #channel 12 :some topic" do |msg|
    msg.nick= "emmanuel"
    msg.channel = "#channel"
    msg.visible = "12"
    msg.topic = "some topic"
  end

  it_generates IRCParser::Messages::RplListEnd, "323 Wiz :End of /LIST" do |msg|
    msg.nick = "Wiz"
  end

  it_generates IRCParser::Messages::RplChannelModeIs, "324 Wiz #channel o" do |msg|
    msg.nick = "Wiz"
    msg.channel = "#channel"
    msg.mode = "o"
  end

  it_generates IRCParser::Messages::RplNoTopic, "331 Wiz #channel :No topic is set" do |msg|
    msg.nick = "Wiz"
    msg.channel = "#channel"
  end

  it_generates IRCParser::Messages::RplTopic, "332 emmanuel #channel :the topic" do |msg|
    msg.nick = "emmanuel"
    msg.channel = "#channel"
    msg.topic = "the topic"
  end

  it_generates IRCParser::Messages::RplInviting, "341 Wiz #channel nick" do |msg|
    msg.nick = "Wiz"
    msg.channel = "#channel"
    msg.nick_inv = "nick"
  end

  it_generates IRCParser::Messages::RplSummoning, "342 Wiz user :Summoning user to IRC" do |msg|
    msg.nick = "Wiz"
    msg.user = "user"
  end

  it_generates IRCParser::Messages::RplVersion, "351 Wiz version.debuglevel server :the comments" do |msg|
    msg.nick = "Wiz"
    msg.version = "version.debuglevel"
    msg.server = "server"
    msg.comments = "the comments"
  end

  it_generates IRCParser::Messages::RplWhoReply, "352 nick #channel user host server nick H*@ :10 John B. Jovi" do |msg| # <H|G>[*][@|+]
    msg.nick = "nick"
    msg.channel = "#channel"
    msg.user = "user"
    msg.host = "host"
    msg.server = "server"
    msg.user_nick = "nick"
    msg.flags = "H*@"
    msg.here! true
    msg.ircop! true
    msg.opped! true
    msg.hopcount = 10
    msg.realname = "John B. Jovi"
  end

  it_generates IRCParser::Messages::RplEndOfWho, "315 Wiz pattern :End of /WHO list" do |msg|
    msg.nick = "Wiz"
    msg.pattern = "pattern"
  end

  it_generates IRCParser::Messages::RplNamReply, "353 Wiz #channel :@nick1 +nick2 nick3" do |msg|
    msg.nick= "Wiz"
    msg.channel=  "#channel"
    msg.nicks_with_flags= %w|@nick1 +nick2 nick3|
  end

  it "can assign nicks to 353 replies", :focus => true do
    m = IRCParser.message(:rpl_nam_reply) { |m| m.channel, m.nicks_with_flags = "#chan", "Emmanuel" }.to_s
    m = IRCParser.parse(m.to_s)
    m.nicks_with_flags.should == ["Emmanuel"]
  end

  it_generates IRCParser::Messages::RplEndOfNames, "366 #channel :End of /NAMES list" do |msg|
    msg.channel = "#channel"
  end

  it_generates IRCParser::Messages::RplLinks, "364 Wiz mask server.com :10 server info" do |msg|
    msg.nick = "Wiz"
    msg.mask = "mask"
    msg.server = "server.com"
    msg.hopcount = 10
    msg.server_info = "server info"
  end

  it_generates IRCParser::Messages::RplEndOfLinks, "365 Wiz mask :End of /LINKS list" do |msg|
    msg.nick = "Wiz"
    msg.mask = "mask"
  end

  it_generates IRCParser::Messages::RplBanList, "367 Wiz @channel banid" do |msg|
    msg.nick = "Wiz"
    msg.channel = "@channel"
    msg.ban_id = "banid"
  end

  it_generates IRCParser::Messages::RplEndOfBanList, "368 Wiz &channel :End of channel ban list" do |msg|
    msg.nick = "Wiz"
    msg.channel = "&channel"
  end

  it_generates IRCParser::Messages::RplInfo, "371 Wiz :Some Message" do |msg|
    msg.nick = "Wiz"
    msg.info = "Some Message"
  end

  it_generates IRCParser::Messages::RplEndOfInfo, "374 Wiz :End of /INFO list" do |msg|
    msg.nick = "Wiz"
  end

  it_generates IRCParser::Messages::RplMotdStart, "375 Wiz :- pepito.com Message of the day -" do |msg|
    msg.nick = "Wiz"
    msg.server = "pepito.com"
  end

  it_generates IRCParser::Messages::RplMotd, "372 Wiz :- This is the very cool motd" do |msg|
    msg.nick = "Wiz"
    msg.motd = "This is the very cool motd"
  end

  it_generates IRCParser::Messages::RplEndOfMotd, "376 Wiz :End of /MOTD command" do |msg|
    msg.nick = "Wiz"
  end

  it_generates IRCParser::Messages::RplYouReOper, "381 Wiz :You are now an IRC operator" do |msg|
    msg.nick = "Wiz"
  end

  it_generates IRCParser::Messages::RplRehashing, "382 Wiz config.sys :Rehashing" do |msg|
    msg.nick = "Wiz"
    msg.config_file = "config.sys"
  end

  it_generates IRCParser::Messages::RplTime, "391 Wiz server.com :10:10pm" do |msg|
    msg.nick = "Wiz"
    msg.server = "server.com"
    msg.local_time = "10:10pm"
  end

  it_generates IRCParser::Messages::RplUsersStart, "392 Wiz :UserID   Terminal  Host" do |msg|
    msg.nick = "Wiz"
  end

  it_generates IRCParser::Messages::RplUsers, "393 Wiz :012344567 012345678 01234567" do |msg|
    msg.nick = "Wiz"
    msg.users = "012344567 012345678 01234567"
  end

  it_generates IRCParser::Messages::RplEndOfUsers, "394 Wiz :End of users" do |msg|
    msg.nick = "Wiz"
  end

  it_generates IRCParser::Messages::RplNoUsers, "395 Wiz :Nobody logged in" do |msg|
    msg.nick = "Wiz"
  end

  it_generates IRCParser::Messages::RplTraceLink, "200 Wiz Link 1.10 destination.com next_server.net" do |msg|
    msg.nick = "Wiz"
    msg.version = "1.10"
    msg.destination = "destination.com"
    msg.next_server = "next_server.net"
  end

  it_generates IRCParser::Messages::RplTraceConnecting, "201 Wiz Try. class server" do |msg|
    msg.nick = "Wiz"
    msg.klass = "class"
    msg.server = "server"
  end

  it_generates IRCParser::Messages::RplTraceHandshake, "202 Wiz H.S. class server" do |msg|
    msg.nick = "Wiz"
    msg.klass = "class"
    msg.server = "server"
  end

  it_generates IRCParser::Messages::RplTraceUnknown, "203 Wiz ???? class 10.2.10.20" do |msg|
    msg.nick = "Wiz"
    msg.klass = "class"
    msg.ip_address = "10.2.10.20"
  end

  it_generates IRCParser::Messages::RplTraceOperator, "204 Wiz Oper class nick" do |msg|
    msg.nick = "Wiz"
    msg.klass = "class"
    msg.user_nick = "nick"
  end

  it_generates IRCParser::Messages::RplTraceUser, "205 Wiz User class nick" do |msg|
    msg.nick = "Wiz"
    msg.klass = "class"
    msg.user_nick = "nick"
  end

  it_generates IRCParser::Messages::RplTraceServer, "206 Wiz Serv class 10S 20C server nick!user@host" do |msg|
    msg.nick = "Wiz"
    msg.klass    = "class"
    msg.intS     = "10S"
    msg.intC     = "20C"
    msg.server   = "server"
    msg.identity = "nick!user@host"
  end

  it_generates IRCParser::Messages::RplTraceNewType, "208 Wiz newtype 0 client_name" do |msg|
    msg.nick = "Wiz"
    msg.new_type = "newtype"
    msg.client_name = "client_name"
  end

  it_generates IRCParser::Messages::RplTraceLog, "261 Wiz File logfile.log 2000" do |msg|
    msg.nick = "Wiz"
    msg.logfile = "logfile.log"
    msg.debug_level = "2000"
  end

  it_generates IRCParser::Messages::RplStatsLinkInfo, "211 Wiz linkname sendq 123 2048 456 1024 100" do |msg|
    msg.nick = "Wiz"
    msg.linkname= "linkname"
    msg.sendq= "sendq"
    msg.sent_messages= 123
    msg.sent_bytes= 2048
    msg.received_messages= 456
    msg.received_bytes= 1024
    msg.time_open= 100
  end

  it_generates IRCParser::Messages::RplStatsCommands, "212 Wiz command 10" do |msg|
    msg.nick = "Wiz"
    msg.command = "command"
    msg.count = 10
  end

  it_generates IRCParser::Messages::RplStatsCLine, "213 Wiz C host * name 1232 class" do |msg|
    msg.nick = "Wiz"
    msg.host = "host"
    msg.name_param = "name"
    msg.port = "1232"
    msg.klass = "class"
  end

  it_generates IRCParser::Messages::RplStatsNLine, "214 Wiz N host * name 1232 class" do |msg|
    msg.nick = "Wiz"
    msg.host = "host"
    msg.name_param = "name"
    msg.port = "1232"
    msg.klass = "class"
  end

  it_generates IRCParser::Messages::RplStatsILine, "215 Wiz I host1 * host2 1232 class" do |msg|
    msg.nick = "Wiz"
    msg.host = "host1"
    msg.second_host = "host2"
    msg.port = "1232"
    msg.klass = "class"
  end

  it_generates IRCParser::Messages::RplStatsKLine, "216 Wiz K host * username 1232 class" do |msg|
    msg.nick = "Wiz"
    msg.host = "host"
    msg.username = "username"
    msg.port = "1232"
    msg.klass = "class"
  end

  it_generates IRCParser::Messages::RplStatsYLine, "218 Wiz Y class 10 20 30" do |msg|
    msg.nick = "Wiz"
    msg.klass = "class"
    msg.ping_frequency = 10
    msg.connect_frequency = 20
    msg.max_sendq = 30
  end

  it_generates IRCParser::Messages::RplEndOfStats, "219 Wiz L :End of /STATS report" do |msg|
    msg.nick = "Wiz"
    msg.stats_letter= "L"
  end

  it_generates IRCParser::Messages::RplStatsLLine, "241 Wiz L hostmask * servername.com 20" do |msg|
    msg.nick = "Wiz"
    msg.host_mask = "hostmask"
    msg.server_name = "servername.com"
    msg.max_depth = 20
  end

  it_generates IRCParser::Messages::RplStatsUptime, "242 Wiz :Server Up 20 days 10:30:30" do |msg|
    msg.nick = "Wiz"
    msg.days = "20"
    msg.time = "10:30:30"
  end

  it_generates IRCParser::Messages::RplStatsOLine, "243 Wiz O hostmask * name" do |msg|
    msg.nick = "Wiz"
    msg.host_mask = "hostmask"
    msg.name_param = "name"
  end

  it_generates IRCParser::Messages::RplStatsHLine, "244 Wiz H hostmask * servername" do |msg|
    msg.nick = "Wiz"
    msg.host_mask = "hostmask"
    msg.server_name = "servername"
  end

  it_generates IRCParser::Messages::RplUModeIs, ":server 221 Wiz nick +i" do |msg|
    msg.prefix = "server"
    msg.nick   = "Wiz"
    msg.user_nick = "nick"
    msg.flags  = "+i"
  end

  it_generates IRCParser::Messages::RplLUserClient, "251 Wiz :There are 10 users and 20 invisible on 30 servers" do |msg|
    msg.nick = "Wiz"
    msg.users_count = 10
    msg.invisible_count = 20
    msg.servers = 30
  end

  it_generates IRCParser::Messages::RplLUserOp, "252 Wiz 10 :operator(s) online" do |msg|
    msg.nick = "Wiz"
    msg.operator_count = 10
  end

  it_generates IRCParser::Messages::RplLUserUnknown, "253 Wiz 7 :unknown connection(s)" do |msg|
    msg.nick = "Wiz"
    msg.connections = 7
  end

  it_generates IRCParser::Messages::RplLUserChannels, "254 Wiz 3 :channels formed" do |msg|
    msg.nick = "Wiz"
    msg.channels_count = 3
  end

  it_generates IRCParser::Messages::RplLUserMe, "255 Wiz :I have 8 clients and 3 servers" do |msg|
    msg.nick = "Wiz"
    msg.clients_count = 8
    msg.servers_count = 3
  end

  it_generates IRCParser::Messages::RplAdminMe, "256 Wiz server.com :Administrative info" do |msg|
    msg.nick = "Wiz"
    msg.server = "server.com"
  end

  it_generates IRCParser::Messages::RplAdminLoc1, "257 Wiz :info" do |msg|
    msg.nick = "Wiz"
    msg.info = "info"
  end

  it_generates IRCParser::Messages::RplAdminLoc2, "258 Wiz :info" do |msg|
    msg.nick = "Wiz"
    msg.info = "info"
  end

  it_generates IRCParser::Messages::RplAdminEmail, "259 Wiz :info" do |msg|
    msg.nick = "Wiz"
    msg.info = "info"
  end

end
