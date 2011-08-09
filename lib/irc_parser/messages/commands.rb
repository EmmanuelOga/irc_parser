module IRCParser::Messages
  define_message :Admin   , :target
  define_message :Away    , :away_message => :postfix
  define_message :Connect , :target_server, :port, :remote_server
  define_message :Info    , :target
  define_message :Invite  , :to_nick, :channel
  define_message :Join    , {:channels => {:csv => ","}}, {:keys => {:csv => ","}}
  define_message :Kick    , {:channels => {:csv => ","}}, {:users => {:csv => ","}}, :kick_message => :postfix
  define_message :Kill    , :nick, :kill_message => :postfix
  define_message :Links   , :remote_server, :server_mask
  define_message :List    , :channels => {:csv => ","}
  define_message :Names   , :channels => {:csv => ","}
  define_message :Oper    , :user, :password
  define_message :Part    , {:channels => {:csv => ","}}, :part_message => :postfix
  define_message :Pass    , :password
  define_message :Ping    , :target, :final_target
  define_message :Pong    , :server, :target
  define_message :Quit    , :quit_message => :postfix
  define_message :Rehash
  define_message :Restart
  define_message :SQuit   , :server, :reason => :postfix
  define_message :Stats   , :mode, :server
  define_message :Time    , :for_server
  define_message :Topic   , :channel, :topic => :postfix
  define_message :Trace   , :target
  define_message :User    , :user, {:mode => { :default => "*" }}, {:servername => { :default => "*" }}, :realname => :postfix
  define_message :Users   , :target
  define_message :Version , :server
  define_message :WallOps , :wall_message => :postfix

  define_message :Mode, :target, :flags, :limit, :user, :ban_mask do

    # Channel Parameters: <channel> {[+|-]|o|p|s|i|t|n|b|v} [<limit>] [<user>] [<ban mask>]
    # User Parameters: <nickname> {[+|-]|i|w|s|o}
    def initialize(prefix, params = [], &block)
      super(prefix, *params)

      return if params == nil || params.length <= 1

      if params.length != 5 && params.length != 2
        self.target = params[0]
        self.flags = params[1]

        if remaining = params[2..-1]
          if remaining.first =~ /\d+/ || self.flags =~ /\+k/
            self.limit = remaining.shift
          elsif self.flags =~ /\+b/
            self.ban_mask = remaining.first
          else
            self.user, self.ban_mask = *remaining
          end
        end
      end

      self.flags = self.flags.downcase if self.flags
    end

    def for_channel?
      IRCParser::Helper.valid_channel_name?(target)
    end

    def for_user?
      IRCParser::Helper.valid_nick?(target)
    end

    CHANNEL_MODES = {
      :invitation          => "I", # set/remove an invitation mask to automatically override the invite-only flag;
      :exception           => "e", # set/remove an exception mask to override a ban mask;
      :quiet               => "q", # toggle the quiet channel flag;
      :reop                => "r", # toggle the server reop channel flag;
      :anonymous           => "a", # toggle the anonymous channel flag;
      :ban_mask            => "b", # set a ban mask to keep users out;
      :creator             => "O", # give "channel creator" status;
      :invite_only         => "i", # invite-only channel flag;
      :moderated           => "m", # moderated channel;
      :no_foreign_messages => "n", # no messages to channel from clients on the outside;
      :operator            => "o", # give/take channel operator privileges;
      :password            => "k", # set a channel key (password).
      :private             => "p", # private channel flag;
      :secret              => "s", # secret channel flag;
      :speaker             => "v", # give/take the ability to speak on a moderated channel;
      :topic_by_op_only    => "t", # topic settable by channel operator only flag;
      :users_limit         => "l"  # set the user limit to channel;
    }

    def negative_flags?
      flags && ( flags[0,1] == "-" )
    end

    def positive_flags?
      not negative_flags?
    end

    def negative_flags!
      self.flags ||= ""

      case flags[0,1]
      when "-" then # Do nothing
      when "+" then self.flags[0] = "-"
      else
        self.flags.insert(0, "-") # Should not happen. Anyway.
      end
    end

    def positive_flags!
      self.flags ||= ""

      case flags[0,1]
      when "+" then # Do nothing
      when "-" then self.flags[0] = "+"
      else
        self.flags.insert(0, "+") # Should not happen. Anyway.
      end
    end

    CHANNEL_MODES.each do |name, flag|
      define_method("chan_flags_include_#{name}?") do
        flags && for_channel? && flags.include?(flag)
      end

      define_method("chan_#{name}?") do
        flags && for_channel? && flags.include?(flag) && positive_flags?
      end

      define_method("chan_#{name}!") do
        self.flags ||= ""
        self.flags = flags + flag unless flags.include?(flag)
      end
    end

    USER_MODES = {
      :invisible        => "i", # marks a users as invisible;
      :server_receptor  => "s", # marks a user for receipt of server notices;
      :wallops_receptor => "w", # user receives wallops;
      :operator         => "o", # operator flag.
      :away             => "a", # user is flagged as away;
      :restricted       => "r", # restricted user connection;
      :local_operator   => "O"  # local operator flag;
    }

    USER_MODES.each do |name, flag|
      define_method("user_flags_include_#{name}?") do
        flags && for_user? && flags.include?(flag)
      end

      define_method("user_#{name}?") do
        flags && for_user? && flags.include?(flag) && positive_flags?
      end

      define_method("user_#{name}!") do
        self.flags ||= ""
        self.flags = flags + flag unless self.flags.include?(flag)
      end
    end
  end

  # hopcount: removed in RFC 2812
  define_message :Nick, :nick, :hopcount do
    def invalid_nick?
      IRCParser::Helper.invalid_nick?(nick)
    end

    def changing?
      prefix.to_s =~ /\S/
    end
  end

  define_message :Server, :server, :hopcount, :info => :postfix do
    def hopcount
      self[:hopcount].to_i
    end

    # not sure about this one, from RFC 2813
    # http://tools.ietf.org/html/rfc2813#section-4.1.2
    def token
      info
    end
  end

  module MesageMan
    def for_channel?
      IRCParser::Helper.valid_channel_name?(target.to_s)
    end

    def for_user?
      IRCParser::Helper.valid_nick?(target.to_s)
    end

    def for_server_pattern?
      target.to_s =~ /^\$/
    end

    def for_host_pattern?
      target.to_s =~ /^\#/
    end

    def server_pattern
      for_server_pattern? && IRCParser::Helper::parse_regexp(target[1..-1])
    end

    def host_pattern
      for_host_pattern? && IRCParser::Helper::parse_regexp(target[1..-1])
    end
  end

  define_message :PrivMsg, :target, :body => :postfix do
    include MesageMan
  end

  define_message :Notice, :target, :body => :postfix do
    include MesageMan
  end

  define_message :Who, :pattern, :operator do
    alias_method :operator?, :operator

    def for_channel?
      IRCParser::Helper.valid_channel_name?(pattern)
    end

    def operator!(true_or_false = true)
      self.operator = true_or_false ? "o" : ""
    end

    def regexp
      IRCParser::Helper.parse_regexp(pattern)
    end
  end

  define_message :WhoIs, :target, :pattern do
    def initialize(prefix, params = [], &block)
      super(prefix, *params)
      self.target, self.pattern = nil, self.target if params && params.length == 1
    end

    def regexp
      IRCParser::Helper.parse_regexp(pattern)
    end
  end

  define_message :WhoWas, :nick, :count, :server do
    def count
      self[:count].to_i
    end
  end

  define_message :Error, :nick, :error_message => :postfix do
    def initialize(prefix, params = [], &block)
      super(prefix, *params)

      if params
        if params.length == 2
          self.nick, self.error_message = *params
        else
          self.error_message = params.first
        end
      end
    end
  end

  define_message :Summon, :nick, :server

  define_message :UserHost, :nicks => { :csv => " " } do
    def initialize(prefix = nil, *nicks)
      super(prefix, nicks.join(" "))
    end
  end

  define_message :IsOn, :nicks => { :csv => " " } do
    def initialize(prefix = nil, *nicks)
      super(prefix, nicks.join(" "))
    end
  end
end
