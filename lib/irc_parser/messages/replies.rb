class IRCParser::Messages::RplWelcome < IRCParser::Message
  identify_as "001"
  parameters :nick, [:welcome, :user] # User format: nick!user@host

  def initialize(prefix, params = nil)
    super(prefix)
    unless params == nil || params.empty?
      parts = params.last.split(" ")
      self.nick = params.first
      self.user = parts.pop
      self.welcome = parts.join(" ")
    end
  end
end

class IRCParser::Messages::RplYourHost < IRCParser::Message
  identify_as "002"
  parameters :nick, ["Your host is", :server_name, "running version", :version]

  def initialize(prefix, params = nil)
    super(prefix)
    if params
      self.nick = params.first
      if params.last =~ /Your host is (.+) running version (.+)/
        self.server_name = $1.chomp(",")
        self.version = $2
      end
    end
  end
end

class IRCParser::Messages::RplCreated < IRCParser::Message
  identify_as "003"
  parameters :nick, ["This server was created", :date]

  def initialize(prefix, params = nil)
    super(prefix)

    if params
      self.nick = params.first
      self.date = $1 if params.last =~ /created (.+)/
    end
  end
end

class IRCParser::Messages::RplMyInfo < IRCParser::Message
  identify_as "004"
  parameters :nick, :server_name, :version, :available_user_modes, :available_channel_modes
end

class IRCParser::Messages::RplBounce < IRCParser::Message
  identify_as "005"
  parameters :nick, ["Try server", :server_name, "port", :port]

  def initialize(prefix, params = nil)
    super(prefix)
    if params
      self.nick = params.first
      if params.last =~ /Try server (.+) port (.+)/
        self.server_name = $1.to_s.chomp(",")
        self.port = $2
      end
    end
  end
end

class IRCParser::Messages::RplNone < IRCParser::Message
  identify_as '300'
  parameter :nick
end

class IRCParser::Messages::RplUserHost < IRCParser::Message
  identify_as "302"
  @postfixes = 3

  parameter :nick
  parameter :nicks, :csv => true, :separator => " "
  parameter "="
  parameter :host_with_sign
end

class IRCParser::Messages::RplIsOn < IRCParser::Message
  identify_as "303"
  parameter :nick
  parameter :nicks, :csv => true, :separator => " "
end

class IRCParser::Messages::RplAway < IRCParser::Message
  identify_as "301"
  parameters :nick, :away_nick, :message
end

class IRCParser::Messages::RplUnAway < IRCParser::Message
  identify_as '305'
  parameters :nick, "You are no longer marked as being away"
end

class IRCParser::Messages::RplNowAway < IRCParser::Message
  identify_as '306'
  parameters :nick, "You have been marked as being away"
end

class IRCParser::Messages::RplWhoIsUser < IRCParser::Message
  identify_as '311'
  @postfixes = 1
  parameters :nick, :user_nick, :user, :ip, "*", :realname
end

class IRCParser::Messages::RplWhoIsServer < IRCParser::Message
  identify_as '312'
  @postfixes = 1
  parameters :nick, :user, :server, :info
end

class IRCParser::Messages::RplWhoIsOperator < IRCParser::Message
  identify_as '313'
  parameters :nick, :user, "is an IRC operator"
end

class IRCParser::Messages::RplWhoIsIdle < IRCParser::Message
  identify_as '317'
  parameters :nick, :user, :seconds, "seconds idle"
end

class IRCParser::Messages::RplWhoIsChannels < IRCParser::Message
  identify_as "319"
  @postfixes = 1
  parameters :nick, :user
  parameter :channels, :csv => true, :separator => " " # flags: [@|+]
end

class IRCParser::Messages::RplEndOfWhoIs < IRCParser::Message
  identify_as '318'
  parameters :nick, :user_nick, "End of /WHOIS list"
end

class IRCParser::Messages::RplWhoWasUser < IRCParser::Message
  identify_as '314'
  parameters :nick, :user, :host, "*", :realname
end

class IRCParser::Messages::RplEndOfWhoWas < IRCParser::Message
  identify_as '369'
  parameters :nick, "End of WHOWAS"
end

class IRCParser::Messages::RplListStart < IRCParser::Message
  identify_as '321'
  parameters :nick, "Channel", "Users  Name"
end

class IRCParser::Messages::RplList < IRCParser::Message
  identify_as '322'
  @postfixes = 1
  parameters :nick, :channel, :visible, :topic
end

class IRCParser::Messages::RplListEnd < IRCParser::Message
  identify_as '323'
  parameters :nick, "End of /LIST"
end

class IRCParser::Messages::RplChannelModeIs < IRCParser::Message
  identify_as '324'
  parameters :nick, :channel, :mode
end

# http://www.mirc.net/raws/?view=328
# This is sent to you by ChanServ when you join a registered channel.
# :services. 328 emmanueloga #chef :http://www.opscode.com
class IRCParser::Messages::RplChannelServices < IRCParser::Message
  identify_as '328'
  parameters :nick, :channel, :comment
end

# http://www.mirc.net/raws/?view=329
# name given by me. This does not appear in the rfcs.
# :gibson.freenode.net 329 emmanueloga #canal 1263942709
class IRCParser::Messages::RplChannelTimestamp < IRCParser::Message
  identify_as '329'
  parameters :nick, :channel, :timestamp
end

# http://mirc.net/raws/?view=331
# 331 nick #hello :No topic is set
# Looks like the nick needs to be present on the message, despite what mirc.net says.
class IRCParser::Messages::RplNoTopic < IRCParser::Message
  identify_as '331'
  parameter :nick, :default => "="
  parameters :channel, "No topic is set"
end

# http://www.mirc.net/raws/?view=332
# 332 nick #peace&protection :Peace & Protection 3.14abcd, it kicks more ass then that damn taco bell dog on speed
# Looks like the nick needs to be present on the message, despite what mirc.net says.
class IRCParser::Messages::RplTopic < IRCParser::Message
  identify_as '332'
  parameter :nick, :default => "="
  parameters :channel, [:topic]
end

# Raw Numeric 333
# This is returned for a TOPIC request or when you JOIN, if the channel has a topic.
# :gibson.freenode.net 333 emmanuel_oga #RubyOnRails wmoxam!~wmoxam@cmr-208-124-190-170.cr.net.cable.rogers.com 1285016759
# http://www.mirc.net/raws/?view=333
class IRCParser::Messages::RplTopicWithTimestamp < IRCParser::Message
  identify_as '333'
  parameters :nick, :channel, :inviter_prefix, :timestamp
end

class IRCParser::Messages::RplInviting < IRCParser::Message
  identify_as '341'
  parameters :nick, :channel, :nick_inv
end

class IRCParser::Messages::RplSummoning < IRCParser::Message
  identify_as '342'
  parameters :nick, :user, "Summoning user to IRC"
end

class IRCParser::Messages::RplVersion < IRCParser::Message
  identify_as '351'
  parameters :nick, :version, :server, :comments
end

# http://www.mirc.net/raws/?view=352
# Example:
# 352 channel           username   address                             server                          nick      flags :hops info
# 352 #peace&protection IsaacHayes sdn-ar-004mokcitP324.dialsprint.net NewBrunswick.NJ.US.Undernet.Org DrDthmtch H+    :4    Isaac Hayes (QuickScript.ml.org)
class IRCParser::Messages::RplWhoReply < IRCParser::Message
  identify_as "352"

  parameters :channel, :user, :host, :server, :user_nick, :flags, [:hopcount, :realname] # Flags: <H|G>[*][@|+] (here, gone)

  FLAGS_INDEX_ON_PARAMS = 6

  FLAGS = {
    0 => { :here  => "H", :gone => "G" },
    1 => { :ircop => "*" },
    2 => { :opped => "@", :voiced => "+" },
    3 => { :deaf  => "d" }
  }

  def initialize(prefix, params = nil)
    super(prefix, params)

    @flags = Array.new(FLAGS.size)

    if params
      self.hopcount, self.realname = $1, $2.to_s.strip if params.last =~ /\s*(\d+)(.*)$/
      original_flags = params[FLAGS_INDEX_ON_PARAMS] || ""

      FLAGS.each do |index, setters|
        setters.each do |flag, pattern|
          send "#{flag}!", true if original_flags.index(pattern)
        end
      end
    end
  end

  FLAGS.each do |index, flags|
    flags.each do |flag, pattern|
      define_method("#{flag}?") do
        not self.flags.index(pattern).nil?
      end

      define_method("#{flag}!") do |val|
        on = flags[flag]; off = (flags.values - [on]).first
        update_flags(index, val ? on : off)
      end
    end
  end

  def update_flags(index, val)
    @flags[index] = val; @parameters[FLAGS_INDEX_ON_PARAMS] = @flags.join
  end
  private :update_flags
end

class IRCParser::Messages::RplEndOfWho < IRCParser::Message
  identify_as '315'
  parameters :nick, :pattern, "End of /WHO list"
end

# http://www.mirc.net/raws/?view=353
# :rpl_nam_reply >> :sendak.freenode.net 353 emmanuel @ #pipita2 :@emmanuel
class IRCParser::Messages::RplNamReply < IRCParser::Message
  identify_as '353'
  parameter :nick, :default => "="
  parameter :padding, :default => "@"
  parameter :channel
  parameter :nicks_with_flags, :csv => true, :separator => " " # each nick should include flags [[@|+]#{nick}
  @postfixes = 1
end

# http://www.mirc.net/raws/?view=366
# :rpl_end_of_names >> :sendak.freenode.net 366 emmanuel #pipita2 :End of /NAMES list.
class IRCParser::Messages::RplEndOfNames < IRCParser::Message
  identify_as '366'
  parameters :channel, ["End of /NAMES list"]
end

class IRCParser::Messages::RplLinks < IRCParser::Message
  identify_as '364'
  parameters :nick, :mask, :server, [:hopcount, :server_info]

  def initialize(prefix, params = nil)
    super
    self.hopcount, self.server_info = $1, $2.to_s.strip if params && params.last =~ /\s*(\d+)(.*)$/
  end
end

class IRCParser::Messages::RplEndOfLinks < IRCParser::Message
  identify_as '365'
  parameters :nick, :mask, "End of /LINKS list"
end

class IRCParser::Messages::RplBanList < IRCParser::Message
  identify_as '367'
  parameters :nick, :channel, :ban_id
end

class IRCParser::Messages::RplEndOfBanList < IRCParser::Message
  identify_as '368'
  parameters :nick, :channel, "End of channel ban list"
end

class IRCParser::Messages::RplInfo < IRCParser::Message
  identify_as '371'
  parameters :nick, :info
end

class IRCParser::Messages::RplEndOfInfo < IRCParser::Message
  identify_as '374'
  parameters :nick, "End of /INFO list"
end

class IRCParser::Messages::RplMotdStart < IRCParser::Message
  identify_as '375'
  @postfixes = 3
  parameters :nick, "-", :server, "Message of the day -"

  def initialize(prefix, params = nil)
    super(prefix)
    self.server = params.last.to_s =~ /\s*-\s*(.+)Message of the day -/ && $1.strip if params
  end
end

class IRCParser::Messages::RplMotd < IRCParser::Message
  identify_as '372'
  @postfixes = 2

  parameters :nick, "-", :motd

  def initialize(prefix, params = nil)
    super(prefix)
    self.motd = params.last.to_s =~ /^\s*-\s*(.+)/ && $1.strip if params
  end
end

class IRCParser::Messages::RplEndOfMotd < IRCParser::Message
  identify_as '376'
  parameters :nick, "End of /MOTD command"
end

class IRCParser::Messages::RplYouReOper < IRCParser::Message
  identify_as '381'
  parameters :nick, "You are now an IRC operator"
end

class IRCParser::Messages::RplRehashing < IRCParser::Message
  identify_as '382'
  @postfixes = 1
  parameters :nick, :config_file, "Rehashing"
end

class IRCParser::Messages::RplTime < IRCParser::Message
  identify_as '391'
  @postfixes = 1
  parameters :nick, :server, :local_time
end

class IRCParser::Messages::RplUsersStart < IRCParser::Message
  identify_as '392'
  parameters :nick, "UserID   Terminal  Host"
end

class IRCParser::Messages::RplUsers < IRCParser::Message
  identify_as '393'
  @postfixes = 1
  parameters :nick, :users # users format: %-8s %-9s %-8s
end

class IRCParser::Messages::RplEndOfUsers < IRCParser::Message
  identify_as '394'
  parameters :nick, "End of users"
end

class IRCParser::Messages::RplNoUsers < IRCParser::Message
  identify_as '395'
  parameters :nick, "Nobody logged in"
end

class IRCParser::Messages::RplTraceLink < IRCParser::Message
  identify_as '200'
  parameters :nick, "Link", :version, :destination, :next_server
end

class IRCParser::Messages::RplTraceConnecting < IRCParser::Message
  identify_as '201'
  parameters :nick, "Try.", :klass, :server
end

class IRCParser::Messages::RplTraceHandshake < IRCParser::Message
  identify_as '202'
  parameters :nick, "H.S.", :klass, :server
end

class IRCParser::Messages::RplTraceUnknown < IRCParser::Message
  identify_as '203'
  parameters :nick, "????", :klass, :ip_address
end

class IRCParser::Messages::RplTraceOperator < IRCParser::Message
  identify_as '204'
  parameters :nick, "Oper", :klass, :user_nick
end

class IRCParser::Messages::RplTraceUser < IRCParser::Message
  identify_as '205'
  parameters :nick, "User", :klass, :user_nick
end

class IRCParser::Messages::RplTraceServer < IRCParser::Message
  identify_as '206'
  parameters :nick, "Serv", :klass, :intS, :intC, :server, :identity
end

class IRCParser::Messages::RplTraceNewType < IRCParser::Message
  identify_as '208'
  parameters :nick, :new_type, "0", :client_name
end

class IRCParser::Messages::RplTraceLog < IRCParser::Message
  identify_as '261'
  parameters :nick, "File", :logfile, :debug_level
end

class IRCParser::Messages::RplStatsLinkInfo < IRCParser::Message
  identify_as '211'
  parameters :nick, :linkname, :sendq, :sent_messages, :sent_bytes, :received_messages, :received_bytes, :time_open
end

class IRCParser::Messages::RplStatsCommands < IRCParser::Message
  identify_as '212'
  parameters :nick, :command, :count
end

class IRCParser::Messages::RplStatsCLine < IRCParser::Message
  identify_as '213'
  parameters :nick, "C", :host, "*", :name_param, :port, :klass
end

class IRCParser::Messages::RplStatsNLine < IRCParser::Message
  identify_as '214'
  parameters :nick, "N", :host, "*", :name_param, :port, :klass
end

class IRCParser::Messages::RplStatsILine < IRCParser::Message
  identify_as '215'
  parameters :nick, "I", :host, "*", :second_host, :port, :klass
end

class IRCParser::Messages::RplStatsKLine < IRCParser::Message
  identify_as '216'
  parameters :nick, "K", :host, "*", :username, :port, :klass
end

class IRCParser::Messages::RplStatsYLine < IRCParser::Message
  identify_as '218'
  parameters :nick, "Y", :klass, :ping_frequency, :connect_frequency, :max_sendq
end

class IRCParser::Messages::RplStatsOLine < IRCParser::Message
  identify_as '243'
  parameters :nick, "O", :host_mask, "*",  :name_param
end

class IRCParser::Messages::RplStatsHLine < IRCParser::Message
  identify_as '244'
  parameters :nick, "H", :host_mask, "*",  :server_name
end

class IRCParser::Messages::RplStatsLLine < IRCParser::Message
  identify_as '241'
  parameters :nick, "L", :host_mask, "*", :server_name, :max_depth
end

class IRCParser::Messages::RplEndOfStats < IRCParser::Message
  identify_as '219'
  parameters :nick, :stats_letter, "End of /STATS report"
end

class IRCParser::Messages::RplStatsUptime < IRCParser::Message
  identify_as '242'
  parameters :nick, ["Server Up", :days, "days", :time] # time format : %d:%02d:%02d

  def initialize(prefix, params = nil)
    super(prefix)
    if params
      self.days = params.last.to_s.scan(/\d+/).first
      self.time = ( params.last.to_s =~ /days(.*)$/ ) && $1.strip
    end
  end
end

class IRCParser::Messages::RplUModeIs < IRCParser::Message
  identify_as '221'
  parameters :nick
  parameters :user_nick
  parameters :flags
end

class IRCParser::Messages::RplStatsDLine < IRCParser::Message
  identify_as '250'
  parameters :nick, ["Highest connection count:", :connections, "(", :clients, ") (", :connections_received, "connections received"]
end

# Name given by me, this message does not appear in the RFCs
# http://www.mirc.net/raws/?view=265
class IRCParser::Messages::RplLUserCount < IRCParser::Message
  identify_as '265'
  parameters :nick, :current, :max, ["Current local users"]
end

# Name given by me, this message does not appear in the RFCs
# http://www.mirc.net/raws/?view=266
class IRCParser::Messages::RplGlobalLUserCount < IRCParser::Message
  identify_as '266'
  parameters :nick, :current, :max, ["Current global users"]
end

class IRCParser::Messages::RplLUserClient < IRCParser::Message
  identify_as '251'
  parameters :nick, ["There are", :users_count, "users and", :invisible_count, "invisible on", :servers, "servers"]

  def initialize(prefix, params = nil)
    super(prefix)
    self.users_count, self.invisible_count, self.servers = params.last.to_s.scan(/\d+/) if params
  end
end

class IRCParser::Messages::RplLUserOp < IRCParser::Message
  identify_as '252'
  parameters :nick, :operator_count, "operator(s) online"
end

class IRCParser::Messages::RplLUserUnknown < IRCParser::Message
  identify_as '253'
  parameters :nick, :connections, "unknown connection(s)"
end

class IRCParser::Messages::RplLUserChannels < IRCParser::Message
  identify_as '254'
  parameters :nick, :channels_count, "channels formed"
end

class IRCParser::Messages::RplLUserMe < IRCParser::Message
  identify_as '255'

  parameters :nick, ["I have", :clients_count, "clients and", :servers_count, "servers"]

  def initialize(prefix, params = nil)
    super(prefix)
    self.clients_count, self.servers_count = params.last.to_s.scan(/\d+/) if params
  end
end

class IRCParser::Messages::RplAdminMe < IRCParser::Message
  identify_as '256'
  parameters :nick, :server, "Administrative info"
end

class IRCParser::Messages::RplAdminLoc1 < IRCParser::Message
  identify_as '257'
  @postfixes = 1
  parameters :nick, :info
end

class IRCParser::Messages::RplAdminLoc2 < IRCParser::Message
  identify_as '258'
  @postfixes = 1
  parameters :nick, :info
end

class IRCParser::Messages::RplAdminEmail < IRCParser::Message
  identify_as '259'
  @postfixes = 1
  parameters :nick, :info
end

# Not Used / Reserved ( http://tools.ietf.org/html/rfc1459#section-6.3
# class IRCParser::Messages::RplTraceClass    # '209'
# class IRCParser::Messages::RplStatsQLine    # '217'
# class IRCParser::Messages::RplServiceInfo   # '231'
# class IRCParser::Messages::RplEndOfServices # '232'
# class IRCParser::Messages::RplService       # '233'
# class IRCParser::Messages::RplServList      # '234'
# class IRCParser::Messages::RplServListend   # '235'
# class IRCParser::Messages::RplWhoIsChanOp   # '316'
# class IRCParser::Messages::RplKillDone      # '361'
# class IRCParser::Messages::RplClosing       # '362'
# class IRCParser::Messages::RplCloseend      # '363'
# class IRCParser::Messages::RplInfoStart     # '373'
# class IRCParser::Messages::RplMyPortIs      # '384'
