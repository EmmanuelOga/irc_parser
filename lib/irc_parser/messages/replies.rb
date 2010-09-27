class IRCParser::Messages::RplWelcome < IRCParser::Message
  self.identifier = "001"
  parameters :nick, [:welcome, :user] # User format: nick!user@host

  def initialize(prefix, *params)
    super(prefix)
    unless params.empty?
      parts = params.last.split(" ")
      self.nick = params.first
      self.user = parts.pop
      self.welcome = parts.join(" ")
    end
  end
end

class IRCParser::Messages::RplYourHost < IRCParser::Message
  self.identifier = "002"
  parameters :nick, ["Your host is", :server_name, "running version", :version]

  def initialize(prefix, *params)
    super(prefix)
    self.nick = params.first
    if params.last =~ /Your host is (.+) running version (.+)/
      self.server_name = $1.chomp(",")
      self.version = $2
    end
  end
end

class IRCParser::Messages::RplCreated < IRCParser::Message
  self.identifier = "003"
  parameters :nick, ["This server was created", :date]

  def initialize(prefix, *params)
    super(prefix)
    self.nick = params.first
    self.date = $1 if params.last =~ /created (.+)/
  end
end

class IRCParser::Messages::RplMyInfo < IRCParser::Message
  self.identifier = "004"
  parameters :nick, :server_name, :version, :available_user_modes, :available_channel_modes

  def initialize(prefix, *params)
    super(prefix)
    self.nick = params.first
    super
  end
end

class IRCParser::Messages::RplBounce < IRCParser::Message
  self.identifier = "005"
  parameters :nick, ["Try server", :server_name, "port", :port]

  def initialize(prefix, *params)
    super(prefix)
    self.nick = params.first
    if params.last =~ /Try server (.+) port (.+)/
      self.server_name = $1.to_s.chomp(",")
      self.port = $2
    end
  end
end

class IRCParser::Messages::RplNone < IRCParser::Message
  self.identifier = '300'
  parameter :nick
end

class IRCParser::Messages::RplUserHost < IRCParser::Message
  self.identifier = "302"
  self.postfixes = 3

  parameter :nick
  parameter :nicks, :csv => true, :separator => " "
  parameter "="
  parameter :host_with_sign
end

class IRCParser::Messages::RplIsOn < IRCParser::Message
  self.identifier = "303"
  parameter :nick
  parameter :nicks, :csv => true, :separator => " "
end

class IRCParser::Messages::RplAway < IRCParser::Message
  self.identifier = "301"
  parameters :nick, :away_nick, :message
end

class IRCParser::Messages::RplUnAway < IRCParser::Message
  self.identifier = '305'
  parameters :nick, "You are no longer marked as being away"
end

class IRCParser::Messages::RplNowAway < IRCParser::Message
  self.identifier = '306'
  parameters :nick, "You have been marked as being away"
end

class IRCParser::Messages::RplWhoIsUser < IRCParser::Message
  self.identifier = '311'
  self.postfixes = 1
  parameters :nick, :user_nick, :user, :ip, "*", :real_name
end

class IRCParser::Messages::RplWhoIsServer < IRCParser::Message
  self.identifier = '312'
  self.postfixes = 1
  parameters :nick, :user, :server, :info
end

class IRCParser::Messages::RplWhoIsOperator < IRCParser::Message
  self.identifier = '313'
  parameters :nick, :user, "is an IRC operator"
end

class IRCParser::Messages::RplWhoIsIdle < IRCParser::Message
  self.identifier = '317'
  parameters :nick, :user, :seconds, "seconds idle"
end

class IRCParser::Messages::RplWhoIsChannels < IRCParser::Message
  self.identifier = "319"
  self.postfixes = 1
  parameters :nick, :user, :channels # flags: [@|+]
  def channels
    super.to_s.split(/\s+/)
  end
end

class IRCParser::Messages::RplEndOfWhoIs < IRCParser::Message
  self.identifier = '318'
  parameters :nick, :user_nick, "End of /WHOIS list"
end

class IRCParser::Messages::RplWhoWasUser < IRCParser::Message
  self.identifier = '314'
  parameters :nick, :user, :host, "*", :real_name
end

class IRCParser::Messages::RplEndOfWhoWas < IRCParser::Message
  self.identifier = '369'
  parameters :nick, "End of WHOWAS"
end

class IRCParser::Messages::RplListStart < IRCParser::Message
  self.identifier = '321'
  parameters :nick, "Channel", "Users  Name"
end

class IRCParser::Messages::RplList < IRCParser::Message
  self.identifier = '322'
  self.postfixes = 1
  parameters :nick, :channel, :visible, :topic
end

class IRCParser::Messages::RplListEnd < IRCParser::Message
  self.identifier = '323'
  parameters :nick, "End of /LIST"
end

class IRCParser::Messages::RplChannelModeIs < IRCParser::Message
  self.identifier = '324'
  parameters :nick, :channel, :mode
end

class IRCParser::Messages::RplNoTopic < IRCParser::Message
  self.identifier = '331'
  parameters :nick, :channel, "No topic is set"
end

class IRCParser::Messages::RplTopic < IRCParser::Message
  self.identifier = '332'
  parameters :nick, :channel, :topic
end

class IRCParser::Messages::RplInviting < IRCParser::Message
  self.identifier = '341'
  parameters :nick, :channel, :nick_inv
end

class IRCParser::Messages::RplSummoning < IRCParser::Message
  self.identifier = '342'
  parameters :nick, :user, "Summoning user to IRC"
end

class IRCParser::Messages::RplVersion < IRCParser::Message
  self.identifier = '351'
  parameters :nick, :version, :server, :comments
end

# http://www.mirc.net/raws/?view=352
# Example:
# :osmotic.oftc.net 352 weechat #canal ~emmanuelo 190.190.190.190 osmotic.oftc.net weechat H@ :0 Emmanuel
class IRCParser::Messages::RplWhoReply < IRCParser::Message
  self.identifier = "352"

  parameters :nick, :channel, :user, :host, :server, :user_nick, :flags, [:hopcount, :real_name] # Flags: <H|G>[*][@|+] (here, gone)

  FLAGS_INDEX_ON_PARAMS = 6

  FLAGS = {
    0 => { :here  => "H", :gone => "G" },
    1 => { :ircop => "*" },
    2 => { :opped => "@", :voiced => "+" },
    3 => { :deaf  => "d" }
  }

  def initialize(prefix, *params)
    super(prefix, *params)

    @flags = Array.new(FLAGS.size)

    self.hopcount, self.real_name = $1, $2.to_s.strip if params.last =~ /\s*(\d+)(.*)$/
    original_flags = params[FLAGS_INDEX_ON_PARAMS] || ""

    FLAGS.each do |index, setters|
      setters.each do |flag, pattern|
        send "#{flag}!", true if original_flags.index(pattern)
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
  self.identifier = '315'
  parameters :nick, :pattern, "End of /WHO list"
end

class IRCParser::Messages::RplNamReply < IRCParser::Message
  self.identifier = '353'
  parameters :nick, :channel
  parameter :nicks_with_flags, :csv => true, :separator => " " # each nick should include flags [[@|+]#{nick}
end

class IRCParser::Messages::RplEndOfNames < IRCParser::Message
  self.identifier = '366'
  parameters :nick, :channel, "End of /NAMES list"
end

class IRCParser::Messages::RplLinks < IRCParser::Message
  self.identifier = '364'
  parameters :nick, :mask, :server, [:hopcount, :server_info]

  def initialize(prefix, *params)
    super(prefix, *params)
    self.hopcount, self.server_info = $1, $2.to_s.strip if params.last =~ /\s*(\d+)(.*)$/
  end
end

class IRCParser::Messages::RplEndOfLinks < IRCParser::Message
  self.identifier = '365'
  parameters :nick, :mask, "End of /LINKS list"
end

class IRCParser::Messages::RplBanList < IRCParser::Message
  self.identifier = '367'
  parameters :nick, :channel, :ban_id
end

class IRCParser::Messages::RplEndOfBanList < IRCParser::Message
  self.identifier = '368'
  parameters :nick, :channel, "End of channel ban list"
end

class IRCParser::Messages::RplInfo < IRCParser::Message
  self.identifier = '371'
  parameters :nick, :info
end

class IRCParser::Messages::RplEndOfInfo < IRCParser::Message
  self.identifier = '374'
  parameters :nick, "End of /INFO list"
end

class IRCParser::Messages::RplMotdStart < IRCParser::Message
  self.identifier = '375'
  self.postfixes = 3
  parameters :nick, "-", :server, "Message of the day -"

  def initialize(prefix, *params)
    super(prefix)
    self.server = params.last.to_s =~ /\s*-\s*(.+)Message of the day -/ && $1.strip
  end
end

class IRCParser::Messages::RplMotd < IRCParser::Message
  self.identifier = '372'
  self.postfixes = 2

  parameters :nick, "-", :motd

  def initialize(prefix, *params)
    super(prefix)
    self.motd = params.last.to_s =~ /^\s*-\s*(.+)/ && $1.strip
  end
end

class IRCParser::Messages::RplEndOfMotd < IRCParser::Message
  self.identifier = '376'
  parameters :nick, "End of /MOTD command"
end

class IRCParser::Messages::RplYouReOper < IRCParser::Message
  self.identifier = '381'
  parameters :nick, "You are now an IRC operator"
end

class IRCParser::Messages::RplRehashing < IRCParser::Message
  self.identifier = '382'
  self.postfixes = 1
  parameters :nick, :config_file, "Rehashing"
end

class IRCParser::Messages::RplTime < IRCParser::Message
  self.identifier = '391'
  self.postfixes = 1
  parameters :nick, :server, :local_time
end

class IRCParser::Messages::RplUsersStart < IRCParser::Message
  self.identifier = '392'
  parameters :nick, "UserID   Terminal  Host"
end

class IRCParser::Messages::RplUsers < IRCParser::Message
  self.identifier = '393'
  self.postfixes = 1
  parameters :nick, :users # users format: %-8s %-9s %-8s
end

class IRCParser::Messages::RplEndOfUsers < IRCParser::Message
  self.identifier = '394'
  parameters :nick, "End of users"
end

class IRCParser::Messages::RplNoUsers < IRCParser::Message
  self.identifier = '395'
  parameters :nick, "Nobody logged in"
end

class IRCParser::Messages::RplTraceLink < IRCParser::Message
  self.identifier = '200'
  parameters :nick, "Link", :version, :destination, :next_server
end

class IRCParser::Messages::RplTraceConnecting < IRCParser::Message
  self.identifier = '201'
  parameters :nick, "Try.", :klass, :server
end

class IRCParser::Messages::RplTraceHandshake < IRCParser::Message
  self.identifier = '202'
  parameters :nick, "H.S.", :klass, :server
end

class IRCParser::Messages::RplTraceUnknown < IRCParser::Message
  self.identifier = '203'
  parameters :nick, "????", :klass, :ip_address
end

class IRCParser::Messages::RplTraceOperator < IRCParser::Message
  self.identifier = '204'
  parameters :nick, "Oper", :klass, :user_nick
end

class IRCParser::Messages::RplTraceUser < IRCParser::Message
  self.identifier = '205'
  parameters :nick, "User", :klass, :user_nick
end

class IRCParser::Messages::RplTraceServer < IRCParser::Message
  self.identifier = '206'
  parameters :nick, "Serv", :klass, :intS, :intC, :server, :identity
end

class IRCParser::Messages::RplTraceNewType < IRCParser::Message
  self.identifier = '208'
  parameters :nick, :new_type, "0", :client_name
end

class IRCParser::Messages::RplTraceLog < IRCParser::Message
  self.identifier = '261'
  parameters :nick, "File", :logfile, :debug_level
end

class IRCParser::Messages::RplStatsLinkInfo < IRCParser::Message
  self.identifier = '211'
  parameters :nick, :linkname, :sendq, :sent_messages, :sent_bytes, :received_messages, :received_bytes, :time_open
end

class IRCParser::Messages::RplStatsCommands < IRCParser::Message
  self.identifier = '212'
  parameters :nick, :command, :count
end

class IRCParser::Messages::RplStatsCLine < IRCParser::Message
  self.identifier = '213'
  parameters :nick, "C", :host, "*", :name_param, :port, :klass
end

class IRCParser::Messages::RplStatsNLine < IRCParser::Message
  self.identifier = '214'
  parameters :nick, "N", :host, "*", :name_param, :port, :klass
end

class IRCParser::Messages::RplStatsILine < IRCParser::Message
  self.identifier = '215'
  parameters :nick, "I", :host, "*", :second_host, :port, :klass
end

class IRCParser::Messages::RplStatsKLine < IRCParser::Message
  self.identifier = '216'
  parameters :nick, "K", :host, "*", :username, :port, :klass
end

class IRCParser::Messages::RplStatsYLine < IRCParser::Message
  self.identifier = '218'
  parameters :nick, "Y", :klass, :ping_frequency, :connect_frequency, :max_sendq
end

class IRCParser::Messages::RplStatsOLine < IRCParser::Message
  self.identifier = '243'
  parameters :nick, "O", :host_mask, "*",  :name_param
end

class IRCParser::Messages::RplStatsHLine < IRCParser::Message
  self.identifier = '244'
  parameters :nick, "H", :host_mask, "*",  :server_name
end

class IRCParser::Messages::RplStatsLLine < IRCParser::Message
  self.identifier = '241'
  parameters :nick, "L", :host_mask, "*", :server_name, :max_depth
end

class IRCParser::Messages::RplEndOfStats < IRCParser::Message
  self.identifier = '219'
  parameters :nick, :stats_letter, "End of /STATS report"
end

class IRCParser::Messages::RplStatsUptime < IRCParser::Message
  self.identifier = '242'
  parameters :nick, ["Server Up", :days, "days", :time] # time format : %d:%02d:%02d

  def initialize(prefix, *params)
    super(prefix)
    self.days = params.last.to_s.scan(/\d+/).first
    self.time = ( params.last.to_s =~ /days(.*)$/ ) && $1.strip
  end
end

class IRCParser::Messages::RplUModeIs < IRCParser::Message
  self.identifier = '221'
  parameters :nick
  parameters :flags
end

class IRCParser::Messages::RplLUserClient < IRCParser::Message
  self.identifier = '251'
  parameters :nick, ["There are", :users_count, "users and", :invisible_count, "invisible on", :servers, "servers"]

  def initialize(prefix, *params)
    super(prefix)
    self.users_count, self.invisible_count, self.servers = *params.last.to_s.scan(/\d+/)
  end
end

class IRCParser::Messages::RplLUserOp < IRCParser::Message
  self.identifier = '252'
  parameters :nick, :operator_count, "operator(s) online"
end

class IRCParser::Messages::RplLUserUnknown < IRCParser::Message
  self.identifier = '253'
  parameters :nick, :connections, "unknown connection(s)"
end

class IRCParser::Messages::RplLUserChannels < IRCParser::Message
  self.identifier = '254'
  parameters :nick, :channels_count, "channels formed"
end

class IRCParser::Messages::RplLUserMe < IRCParser::Message
  self.identifier = '255'

  parameters :nick, ["I have", :clients_count, "clients and", :servers_count, "servers"]

  def initialize(prefix, *params)
    super(prefix)
    self.clients_count, self.servers_count = *params.last.to_s.scan(/\d+/)
  end
end

class IRCParser::Messages::RplAdminMe < IRCParser::Message
  self.identifier = '256'
  parameters :nick, :server, "Administrative info"
end

class IRCParser::Messages::RplAdminLoc1 < IRCParser::Message
  self.identifier = '257'
  self.postfixes = 1
  parameters :nick, :info
end

class IRCParser::Messages::RplAdminLoc2 < IRCParser::Message
  self.identifier = '258'
  self.postfixes = 1
  parameters :nick, :info
end

class IRCParser::Messages::RplAdminEmail < IRCParser::Message
  self.identifier = '259'
  self.postfixes = 1
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
