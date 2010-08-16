IRCParser::Messages::Message.define_reply :Welcome, "001", :nick, :welcome, :user, :postfixes => 2 do # User format: nick!user@host
  def initialize_params(params)
    parts = params.last.split(" ")
    self.nick = params.first
    self.user = parts.pop
    self.welcome = parts.join(" ")
  end
end

IRCParser::Messages::Message.define_reply :YourHost, "002", :nick, "Your host is", :server_name, "running version", :version, :postfixes => 4 do
  def initialize_params(params)
    self.nick = params.first
    if params.last =~ /Your host is (.+) running version (.+)/
      self.server_name = $1.chomp(",")
      self.version = $2
    end
  end
end

IRCParser::Messages::Message.define_reply :Created, "003", :nick, "This server was created", :date, :postfixes => 2 do
  def initialize_params(params)
    self.nick = params.first
    self.date = $1 if params.last =~ /created (.+)/
  end
end

IRCParser::Messages::Message.define_reply :MyInfo, "004", :nick, :server_name, :version, :available_user_modes, :available_channel_modes do
  def initialize_params(params)
    self.nick = params.first
    super
  end
end

IRCParser::Messages::Message.define_reply :Bounce, "005", :nick, "Try server", :server_name, "port", :port, :postfixes => 4 do
  def initialize_params(params)
    self.nick = params.first
    if params.last =~ /Try server (.+) port (.+)/
      self.server_name = $1.to_s.chomp(",")
      self.port = $2
    end
  end
end

IRCParser::Messages::Message.define_reply :None             , '300'
IRCParser::Messages::Message.define_reply :UserHost         , "302", :nicks_and_hosts # format: <nick>['*'] '=' <'+'|'-'><hostname>

IRCParser::Messages::Message.define_reply :Ison             , "303", :nicks do
  def initialize_params(params)
    self.nicks = params.last.split(" ")
  end
end

IRCParser::Messages::Message.define_reply :Away             , "301", :nick, :message
IRCParser::Messages::Message.define_reply :UnAway           , '305', "You are no longer marked as being away"
IRCParser::Messages::Message.define_reply :NowAway          , '306', "You have been marked as being away"

IRCParser::Messages::Message.define_reply :WhoIsUser        , '311', :nick, :user, :host, :ip, :real_name, :postfixes => 1
IRCParser::Messages::Message.define_reply :WhoIsServer      , '312', :nick, :user, :server, :info, :postfixes => 1
IRCParser::Messages::Message.define_reply :WhoIsOperator    , '313', :nick, :user, "is an IRC operator"
IRCParser::Messages::Message.define_reply :WhoIsIdle        , '317', :nick, :user, :seconds, "seconds idle"
IRCParser::Messages::Message.define_reply :WhoIsChannels    , "319", :nick, :user, :channels, :postfixes => 1 do # flags: [@|+]
  def channels
    super.to_s.split(/\s+/)
  end
end

IRCParser::Messages::Message.define_reply :EndOfWhoIs       , '318', :nick, "End of /WHOIS list"

IRCParser::Messages::Message.define_reply :WhoWasUser       , '314', :nick, :user, :host, "*", :real_name
IRCParser::Messages::Message.define_reply :EndOfWhoWas      , '369', :nick, "End of WHOWAS"

IRCParser::Messages::Message.define_reply :ListStart        , '321', "Channel", "Users  Name"
IRCParser::Messages::Message.define_reply :List             , '322', :nick, :channel, :visible, :topic, :postfixes => 1
IRCParser::Messages::Message.define_reply :ListEnd          , '323', "End of /LIST"

IRCParser::Messages::Message.define_reply :ChannelModeIs    , '324', :channel, :mode, :mode_params

IRCParser::Messages::Message.define_reply :NoTopic          , '331', :channel, "No topic is set"

IRCParser::Messages::Message.define_reply :Topic            , '332', :nick, :channel, :topic

IRCParser::Messages::Message.define_reply :Inviting         , '341', :channel, :nick
IRCParser::Messages::Message.define_reply :Summoning        , '342', :user, "Summoning user to IRC"
IRCParser::Messages::Message.define_reply :Version          , '351', :version, :server, :comments

# http://www.mirc.net/raws/?view=352
# nick0: added cause freenode's server sends it
IRCParser::Messages::Message.define_reply :WhoReply         , "352", :nick0, :channel, :user, :host, :server, :nick, :flags, :hopcount, :real_name, :postfixes => 2 do # Flags: <H|G>[*][@|+] (here, gone)

  FLAGS_INDEX_ON_PARAMS = 6
  FLAGS = {
    0 => { :here  => "H", :gone => "G" },
    1 => { :ircop => "*" },
    2 => { :opped => "@", :voiced => "+" },
    3 => { :deaf  => "d" }
  }

  def initialize
    @flags = Array.new(FLAGS.size)
    super
  end

  def initialize_params(vals)
    super(vals)
    self.hopcount, self.real_name = $1, $2.to_s.strip if vals.last =~ /\s*(\d+)(.*)$/
    original_flags = vals[FLAGS_INDEX_ON_PARAMS]
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

  def nick=(val)
    self.nick0 = val
    super(val)
  end
  private :nick0=, :nick0

  def update_flags(index, val)
    @flags[index] = val; @params[FLAGS_INDEX_ON_PARAMS] = @flags.join
  end
  private :update_flags
end

IRCParser::Messages::Message.define_reply :EndOfWho         , '315', :pattern, "End of /WHO list"

IRCParser::Messages::Message.define_reply :NamReply         , '353', "=", :channel, :nicks, :postfixes => 1 do # each nick should include flags [[@|+]#{nick}
  def nicks
    super.to_s.split(/\s+/)
  end
end

IRCParser::Messages::Message.define_reply :EndOfNames       , '366', :channel, "End of /NAMES list"

IRCParser::Messages::Message.define_reply :Links            , '364', :mask, :server, :hopcount, :server_info, :postfixes => 2 do
  def initialize_params(vals)
    super(vals)
    self.hopcount, self.server_info = $1, $2.to_s.strip if vals.last =~ /\s*(\d+)(.*)$/
  end
end

IRCParser::Messages::Message.define_reply :EndOfLinks       , '365', :mask, "End of /LINKS list"
IRCParser::Messages::Message.define_reply :BanList          , '367', :channel, :ban_id
IRCParser::Messages::Message.define_reply :EndOfBanList     , '368', :channel, "End of channel ban list"
IRCParser::Messages::Message.define_reply :Info             , '371', :info
IRCParser::Messages::Message.define_reply :EndOfInfo        , '374', "End of /INFO list"

IRCParser::Messages::Message.define_reply :MotdStart        , '375', "-", :server, "Message of the day -", :postfixes => 3 do
  def initialize_params(vals)
    self.server = vals.last.to_s =~ /\s*-\s*(.+)Message of the day -/ && $1.strip
  end
end

IRCParser::Messages::Message.define_reply :Motd             , '372', "-", :motd, :postfixes => 2 do
  def initialize_params(vals)
    self.motd = vals.last.to_s =~ /^\s*-\s*(.+)/ && $1.strip
  end
end

IRCParser::Messages::Message.define_reply :EndOfMotd        , '376', "End of /MOTD command"

IRCParser::Messages::Message.define_reply :YouReOper        , '381', "You are now an IRC operator"
IRCParser::Messages::Message.define_reply :Rehashing        , '382', :config_file, "Rehashing", :postfixes => 1
IRCParser::Messages::Message.define_reply :Time             , '391', :server, :local_time, :postfixes => 1
IRCParser::Messages::Message.define_reply :UsersStart       , '392', "UserID   Terminal  Host"
IRCParser::Messages::Message.define_reply :Users            , '393', :users, :postfixes => 1 # users format: %-8s %-9s %-8s
IRCParser::Messages::Message.define_reply :EndOfUsers       , '394', "End of users"
IRCParser::Messages::Message.define_reply :NoUsers          , '395', "Nobody logged in"
IRCParser::Messages::Message.define_reply :TraceLink        , '200', "Link", :version, :destination, :next_server
IRCParser::Messages::Message.define_reply :TraceConnecting  , '201', "Try.", :klass, :server
IRCParser::Messages::Message.define_reply :TraceHandshake   , '202', "H.S.", :klass, :server
IRCParser::Messages::Message.define_reply :TraceUnknown     , '203', "????", :klass, :ip_address
IRCParser::Messages::Message.define_reply :TraceOperator    , '204', "Oper", :klass, :nick
IRCParser::Messages::Message.define_reply :TraceUser        , '205', "User", :klass, :nick
IRCParser::Messages::Message.define_reply :TraceServer      , '206', "Serv", :klass, :intS, :intC, :server, :identifier
IRCParser::Messages::Message.define_reply :TraceNewType     , '208', :new_type, "0", :client_name
IRCParser::Messages::Message.define_reply :TraceLog         , '261', "File", :logfile, :debug_level

IRCParser::Messages::Message.define_reply :StatsLinkInfo    , '211', :linkname, :sendq, :sent_messages, :sent_bytes, :received_messages, :received_bytes, :time_open
IRCParser::Messages::Message.define_reply :StatsCommands    , '212', :command, :count
IRCParser::Messages::Message.define_reply :StatsCLine       , '213', "C", :host, "*", :name_param, :port, :klass
IRCParser::Messages::Message.define_reply :StatsNLine       , '214', "N", :host, "*", :name_param, :port, :klass
IRCParser::Messages::Message.define_reply :StatsILine       , '215', "I", :host, "*", :second_host, :port, :klass
IRCParser::Messages::Message.define_reply :StatsKLine       , '216', "K", :host, "*", :username, :port, :klass
IRCParser::Messages::Message.define_reply :StatsYLine       , '218', "Y", :klass, :ping_frequency, :connect_frequency, :max_sendq
IRCParser::Messages::Message.define_reply :StatsOLine       , '243', "O", :host_mask, "*",  :name_param
IRCParser::Messages::Message.define_reply :StatsHLine       , '244', "H", :host_mask, "*",  :server_name
IRCParser::Messages::Message.define_reply :StatsLLine       , '241', "L", :host_mask, "*", :server_name, :max_depth
IRCParser::Messages::Message.define_reply :EndOfStats       , '219', :stats_letter, "End of /STATS report"

IRCParser::Messages::Message.define_reply :StatsUptime      , '242', "Server Up", :days, "days", :time, :postfixes => 4 do # time format : %d:%02d:%02d
  def initialize_params(params)
    self.days = params.last.to_s.scan(/\d+/).first
    self.time = ( params.last.to_s =~ /days(.*)$/ ) && $1.strip
  end
end

IRCParser::Messages::Message.define_reply :UModeIs          , '221', :user_mode

IRCParser::Messages::Message.define_reply :LUserClient      , '251', "There are", :users_count, "users and", :invisible_count, "invisible on", :servers, "servers", :postfixes => 7 do
  def initialize_params(params)
    self.users_count, self.invisible_count, self.servers = *params.last.to_s.scan(/\d+/)
  end
end

IRCParser::Messages::Message.define_reply :LUserOp          , '252', :operator_count, "operator(s) online"
IRCParser::Messages::Message.define_reply :LUserUnknown     , '253', :connections, "unknown connection(s)"
IRCParser::Messages::Message.define_reply :LUserChannels    , '254', :channels_count, "channels formed"

IRCParser::Messages::Message.define_reply :LUserMe          , '255', "I have", :clients_count, "clients and", :servers_count, "servers", :postfixes => 5 do
  def initialize_params(params)
    self.clients_count, self.servers_count = *params.last.to_s.scan(/\d+/)
  end
end

IRCParser::Messages::Message.define_reply :AdminMe          , '256', :server, "Administrative info"
IRCParser::Messages::Message.define_reply :AdminLoc1        , '257', :info, :postfixes => 1
IRCParser::Messages::Message.define_reply :AdminLoc2        , '258', :info, :postfixes => 1
IRCParser::Messages::Message.define_reply :AdminEmail       , '259', :info, :postfixes => 1

# Not Used / Reserved ( http://tools.ietf.org/html/rfc1459#section-6.3
# IRCParser::Messages::Message.define_reply :TraceClass       , '209'
# IRCParser::Messages::Message.define_reply :StatsQLine       , '217'
# IRCParser::Messages::Message.define_reply :ServiceInfo      , '231'
# IRCParser::Messages::Message.define_reply :EndOfServices    , '232'
# IRCParser::Messages::Message.define_reply :Service          , '233'
# IRCParser::Messages::Message.define_reply :ServList         , '234'
# IRCParser::Messages::Message.define_reply :ServListend      , '235'
# IRCParser::Messages::Message.define_reply :WhoIsChanOp      , '316'
# IRCParser::Messages::Message.define_reply :KillDone         , '361'
# IRCParser::Messages::Message.define_reply :Closing          , '362'
# IRCParser::Messages::Message.define_reply :Closeend         , '363'
# IRCParser::Messages::Message.define_reply :InfoStart        , '373'
# IRCParser::Messages::Message.define_reply :MyPortIs         , '384'
