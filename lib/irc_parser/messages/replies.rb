module IRCParser::Messages
  define_message :RplWelcome         , "001", :nick, "%{welcome} %{user}"
  define_message :RplYourHost        , "002", :nick, "Your host is %{server_name} running version %{version}"
  define_message :RplCreated         , "003", :nick, "This server was created %{date}"
  define_message :RplMyInfo          , "004", :nick, :server_name, :version, :available_user_modes, :available_channel_modes
  define_message :RplBounce          , "005", :nick, "Try server %{server_name} port %{port}"
  define_message :RplTraceLink       , '200', :nick, "Link", :version, :destination, :next_server
  define_message :RplTraceConnecting , '201', :nick, "Try.", :klass, :server
  define_message :RplTraceHandshake  , '202', :nick, "H.S.", :klass, :server
  define_message :RplTraceUnknown    , '203', :nick, "????", :klass, :ip_address
  define_message :RplTraceOperator   , '204', :nick, "Oper", :klass, :user_nick
  define_message :RplTraceUser       , '205', :nick, "User", :klass, :user_nick
  define_message :RplTraceServer     , '206', :nick, "Serv", :klass, :intS, :intC, :server, :identity
  define_message :RplTraceNewType    , '208', :nick, :new_type, "0", :client_name
  define_message :RplStatsLinkInfo   , '211', :nick, :linkname, :sendq, :sent_messages, :sent_bytes, :received_messages, :received_bytes, :time_open
  define_message :RplStatsCommands   , '212', :nick, :command, :count
  define_message :RplStatsCLine      , '213', :nick, "C", :host, "*", :name_param, :port, :klass
  define_message :RplStatsNLine      , '214', :nick, "N", :host, "*", :name_param, :port, :klass
  define_message :RplStatsILine      , '215', :nick, "I", :host, "*", :second_host, :port, :klass
  define_message :RplStatsKLine      , '216', :nick, "K", :host, "*", :username, :port, :klass
  define_message :RplStatsYLine      , '218', :nick, "Y", :klass, :ping_frequency, :connect_frequency, :max_sendq
  define_message :RplEndOfStats      , '219', :nick, :stats_letter, "End of /STATS report"
  define_message :RplUModeIs         , '221', :nick, :user_nick, :flags
  define_message :RplStatsLLine      , '241', :nick, "L", :host_mask, "*", :server_name, :max_depth
  define_message :RplStatsUptime     , '242', :nick, "Server Up %{days} days %{time}" # time format : %d:%02d:%02d
  define_message :RplStatsOLine      , '243', :nick, "O", :host_mask, "*", :name_param
  define_message :RplStatsHLine      , '244', :nick, "H", :host_mask, "*",  :server_name
  define_message :RplStatsDLine      , '250', :nick, "Highest connection count: %{connections} (%{clients}) (%{connections_received} connections received"
  define_message :RplLUserClient     , '251', :nick, "There are %{users_count} users and %{invisible_count} invisible on %{servers} servers"
  define_message :RplLUserOp         , '252', :nick, :operator_count, "operator(s) online"
  define_message :RplLUserUnknown    , '253', :nick, :connections, "unknown connection(s)"
  define_message :RplLUserChannels   , '254', :nick, :channels_count, "channels formed"
  define_message :RplLUserMe         , '255', :nick, "I have %{clients_count} clients and %{servers_count} servers"
  define_message :RplAdminMe         , '256', :nick, :server, "Administrative info"
  define_message :RplAdminLoc1       , '257', :nick, :info => :postfix
  define_message :RplAdminLoc2       , '258', :nick, :info => :postfix
  define_message :RplAdminEmail      , '259', :nick, :info => :postfix
  define_message :RplTraceLog        , '261', :nick, "File", :logfile, :debug_level
  define_message :RplNone            , "300", :nick
  define_message :RplUserHost        , "302", :nick, "%{users} = %{host_with_sign}"
  define_message :RplAway            , "301", :nick, :away_nick, :message => :postfix
  define_message :RplUnAway          , '305', :nick, "You are no longer marked as being away"
  define_message :RplNowAway         , '306', :nick, "You have been marked as being away"
  define_message :RplWhoIsUser       , '311', :nick, :user_nick, :user, :ip, "*", :realname => :postfix
  define_message :RplWhoIsServer     , '312', :nick, :user, :server, :info => :postfix
  define_message :RplWhoIsOperator   , '313', :nick, :user, "is an IRC operator"
  define_message :RplWhoWasUser      , '314', :nick, :user, :host, "*", :realname => :postfix
  define_message :RplEndOfWho        , '315', :nick, :pattern, "End of /WHO list"
  define_message :RplWhoIsIdle       , '317', :nick, :user, :seconds, "seconds idle"
  define_message :RplEndOfWhoIs      , '318', :nick, :user_nick, "End of /WHOIS list"
  define_message :RplListStart       , '321', :nick, "Channel", "Users  Name"
  define_message :RplList            , '322', :nick, :channel, :visible, :topic => :postfix
  define_message :RplListEnd         , '323', :nick, "End of /LIST"
  define_message :RplChannelModeIs   , '324', :nick, :channel, :mode
  define_message :RplInviting        , '341', :nick, :channel, :nick_inv
  define_message :RplSummoning       , '342', :nick, :user, "Summoning user to IRC"
  define_message :RplVersion         , '351', :nick, :version, :server, :comments => :postfix
  define_message :RplLinks           , '364', :nick, :mask, :server, "%{hopcount} %{server_info}"
  define_message :RplEndOfLinks      , '365', :nick, :mask, "End of /LINKS list"
  define_message :RplBanList         , '367', :nick, :channel, :ban_id
  define_message :RplEndOfBanList    , '368', :nick, :channel, "End of channel ban list"
  define_message :RplEndOfWhoWas     , '369', :nick, "End of WHOWAS"
  define_message :RplInfo            , '371', :nick, :info => :postfix
  define_message :RplEndOfInfo       , '374', :nick, "End of /INFO list"
  define_message :RplMotdStart       , '375', :nick, "-%{server} %{message}-"
  define_message :RplMotd            , '372', :nick, "-%{motd}"
  define_message :RplEndOfMotd       , '376', :nick, "End of /MOTD command"
  define_message :RplYouReOper       , '381', :nick, "You are now an IRC operator"
  define_message :RplRehashing       , '382', :nick, :config_file, "Rehashing"
  define_message :RplTime            , '391', :nick, :server, :local_time => :postfix
  define_message :RplUsersStart      , '392', :nick, "UserID   Terminal  Host"
  define_message :RplUsers           , '393', :nick, "%{username} %{ttyline} %{hostname}"
  define_message :RplEndOfUsers      , '394', :nick, "End of users"
  define_message :RplNoUsers         , '395', :nick, "Nobody logged in"

  define_message :RplIsOn, "303", :nick, :nicks => :postfix do
    def nicks
      postfix.split(" ")
    end

    def nicks=(nicks)
      self.postfix = Array(nicks).join(" ")
    end
  end

  define_message :RplWhoIsChannels, "319", :nick, :user, :channels => :postfix do
    def channels
      postfix.split(" ")
    end

    def channels=(val)
      self.postfix = Array(val).join(" ")
    end
  end

  # This message does not appear in the RFCs afaict
  # http://www.mirc.net/raws/?view=265
  define_message :RplLUserCount, '265', :nick, :current, :max, "Current local users"

  # This message does not appear in the RFCs afaict
  # http://www.mirc.net/raws/?view=266
  define_message :RplGlobalLUserCount, '266', :nick, :current, :max, "Current global users"

  # http://www.mirc.net/raws/?view=328
  # This is sent to you by ChanServ when you join a registered channel.
  # :services. 328 emmanueloga #chef :http://www.opscode.com
  define_message :RplChannelServices, '328', :nick, :channel, :comment

  # http://www.mirc.net/raws/?view=329
  # name given by me. This does not appear in the rfcs.
  # :gibson.freenode.net 329 emmanueloga #canal 1263942709
  define_message :RplChannelTimestamp, '329', :nick, :channel, :timestamp

  # http://mirc.net/raws/?view=331
  # 331 nick #hello :No topic is set
  # Looks like the nick needs to be present on the message, despite what mirc.net says.
  define_message :RplNoTopic, '331', :nick, :channel, "No topic is set"

  # http://www.mirc.net/raws/?view=332
  # 332 nick #peace&protection :Peace & Protection 3.14abcd, it kicks more ass then that damn taco bell dog on speed
  # Looks like the nick needs to be present on the message, despite what mirc.net says.
  define_message :RplTopic, '332', :nick, :channel, :topic => :postfix

  # Raw Numeric 333
  # This is returned for a TOPIC request or when you JOIN, if the channel has a topic.
  # :gibson.freenode.net 333 emmanuel_oga #RubyOnRails wmoxam!~wmoxam@cmr-208-124-190-170.cr.net.cable.rogers.com 1285016759
  # http://www.mirc.net/raws/?view=333
  define_message :RplTopicWithTimestamp, '333', :nick, :channel, :inviter_prefix, :timestamp

  # http://www.mirc.net/raws/?view=352
  # Example:
  # 352 channel           username   address                             server                          nick      flags :hops info
  # 352 #peace&protection IsaacHayes sdn-ar-004mokcitP324.dialsprint.net NewBrunswick.NJ.US.Undernet.Org DrDthmtch H+    :4    Isaac Hayes (QuickScript.ml.org)
  # Flags: <H|G>[*][@|+] (here, gone)
  define_message :RplWhoReply, "352", :channel, :user, :host, :server, :user_nick, :flags, "%{hopcount} %{realname}" do
    FLAGS_INDEX_ON_PARAMS = 6

    FLAGS = {
      0 => { :here  => "H", :gone => "G" },
      1 => { :ircop => "*" },
      2 => { :opped => "@", :voiced => "+" },
      3 => { :deaf  => "d" }
    }

    def initialize(prefix, params = [])
      super(prefix, *params)

      @flags = Array.new(FLAGS.size)

      if params
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
      @flags[index] = val
      self.flags = @flags.join
    end
    private :update_flags
  end

  # http://www.mirc.net/raws/?view=353
  # :rpl_nam_reply >> :sendak.freenode.net 353 emmanuel @ #pipita2 :@emmanuel
  # each nick should include flags [[@|+]#{nick}
  define_message :RplNamReply, '353', :nick, "@", :channel do
    def nicks_with_flags
      postfix.split(" ") if postfix
    end

    def nicks_with_flags=(nicks)
      self.postfix= Array(nicks).join(" ")
    end
  end

  # http://www.mirc.net/raws/?view=366
  # :rpl_end_of_names >> :sendak.freenode.net 366 emmanuel #pipita2 :End of /NAMES list.
  define_message :RplEndOfNames, '366', :channel, "End of /NAMES list"

  # Not Used / Reserved ( http://tools.ietf.org/html/rfc1459#section-6.3
  # RplTraceClass    , '209'
  # RplStatsQLine    , '217'
  # RplServiceInfo   , '231'
  # RplEndOfServices , '232'
  # RplService       , '233'
  # RplServList      , '234'
  # RplServListend   , '235'
  # RplWhoIsChanOp   , '316'
  # RplKillDone      , '361'
  # RplClosing       , '362'
  # RplCloseend      , '363'
  # RplInfoStart     , '373'
  # RplMyPortIs      , '384'
end
