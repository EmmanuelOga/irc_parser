class IRCParser::Messages::Join < IRCParser::Message
  parameter :channels , :csv => true
  parameter :keys     , :csv => true
end

class IRCParser::Messages::Mode < IRCParser::Message
  parameter :target
  parameter :flags
  parameter :limit
  parameter :user
  parameter :ban_mask

  # Damned rfc.
  # Channel Parameters: <channel> {[+|-]|o|p|s|i|t|n|b|v} [<limit>] [<user>] [<ban mask>]
  # User Parameters: <nickname> {[+|-]|i|w|s|o}
  def initialize(prefix, params = nil, &block)
    super

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
    IRCParser::Helper.valid_channel_name?(parameters.first.to_s)
  end

  def for_user?
    IRCParser::Helper.valid_nick?(parameters.first.to_s)
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

class IRCParser::Messages::Nick < IRCParser::Message
  parameter :nick
  parameter :hopcount # removed in RFC 2812

  def invalid_nick?
    IRCParser::Helper.invalid_nick?(nick)
  end

  def changing?
    prefix.to_s =~ /\S/
  end
end

class IRCParser::Messages::Oper < IRCParser::Message
  parameter :user
  parameter :password
end

class IRCParser::Messages::Part < IRCParser::Message
  parameter :channels, :csv => true
  parameter :part_message
end

class IRCParser::Messages::Pass < IRCParser::Message
  parameter :password
end

class IRCParser::Messages::Quit < IRCParser::Message
  parameter :quit_message
end

class IRCParser::Messages::Server < IRCParser::Message
  parameter :server
  parameter :hopcount
  parameter :info

  def hopcount
    parameters[1].to_i
  end

  # not sure about this one, from RFC 2813
  # http://tools.ietf.org/html/rfc2813#section-4.1.2
  def token
    parameters[3] if parameters.length == 4
  end

end

class IRCParser::Messages::SQuit < IRCParser::Message
  parameter :server
  parameter :reason
end

class IRCParser::Messages::Topic < IRCParser::Message
  parameter :channel
  parameter :topic
end

class IRCParser::Messages::User < IRCParser::Message
  parameter :user
  parameter :mode,       :default => "*" # rfc 1459, deprecated
  parameter :servername, :default => "*" # rfc 1459, deprecated
  parameter :realname
end

class IRCParser::Messages::Names < IRCParser::Message
  parameter :channels, :csv => true
end

class IRCParser::Messages::List < IRCParser::Message
  parameter :channels, :csv => true
end

class IRCParser::Messages::Invite < IRCParser::Message
  parameter :to_nick
  parameter :channel
end

class IRCParser::Messages::Kick < IRCParser::Message
  parameter :channels, :csv => true
  parameter :users, :csv => true
  parameter :kick_message
end

class IRCParser::Messages::Version < IRCParser::Message
  parameter :server
end

class IRCParser::Messages::Stats < IRCParser::Message
  parameter :mode
  parameter :server
end

class IRCParser::Messages::Links < IRCParser::Message
  parameter :remote_server
  parameter :server_mask

  def initialize(prefix, params = nil, &block)
    super(prefix)

    if params
      case params.length
      when 1 then self.server_mask = params.first
      when 2 then self.remote_server, self.server_mask = *params
      end
    end
  end
end

class IRCParser::Messages::Time < IRCParser::Message
  parameter :for_server
end

class IRCParser::Messages::Connect < IRCParser::Message
  parameter :target_server
  parameter :port
  parameter :remote_server

  def initialize(prefix, params = nil, &block)
    super(prefix)
    if params
      case params.length
      when 1 then self.target_server = params.first
      when 2 then self.target_server, self.remote_server = *params
      when 3 then self.target_server, self.port, self.remote_server = *params
      end
    end
  end
end

class IRCParser::Messages::Trace < IRCParser::Message
  parameter :target
end

class IRCParser::Messages::Admin < IRCParser::Message
  parameter :target
end

class IRCParser::Messages::Info < IRCParser::Message
  parameter :target
end

module IRCParser::Messages::MesageMan
  def self.included(klass)
    klass.class_eval do
      parameters :target, :body
      alias_method :server_pattern=, :target=
      alias_method :host_pattern=, :target=
    end
  end

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
    for_server_pattern? && IRCParser::Helper::parse_regexp(parameters.first[1..-1])
  end

  def host_pattern
    for_host_pattern? && IRCParser::Helper::parse_regexp(parameters.first[1..-1])
  end
end

class IRCParser::Messages::PrivMsg < IRCParser::Message
  include IRCParser::Messages::MesageMan
end

class IRCParser::Messages::Notice < IRCParser::Message
  include IRCParser::Messages::MesageMan
end

class IRCParser::Messages::Who < IRCParser::Message
  parameter :pattern
  parameter :operator

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

class IRCParser::Messages::WhoIs < IRCParser::Message
  parameter :target
  parameter :pattern

  def initialize(prefix, params = nil, &block)
    super
    self.target, self.pattern = nil, self.target if params && params.length == 1
  end

  def regexp
    IRCParser::Helper.parse_regexp(pattern)
  end
end

class IRCParser::Messages::Kill < IRCParser::Message
  parameter :nick
  parameter :kill_message
end

class IRCParser::Messages::WhoWas < IRCParser::Message
  parameter :nick
  parameter :count
  parameter :server

  def count
    parameters[1].to_i
  end
end

class IRCParser::Messages::Ping < IRCParser::Message
  parameter :target
  parameter :final_target
end

class IRCParser::Messages::Pong < IRCParser::Message
  parameter :server
  parameter :target
end

class IRCParser::Messages::Error < IRCParser::Message
  parameter :nick
  parameter :error_message

  def initialize(prefix, params = nil, &block)
    super(prefix)

    if params
      if params.length == 2
        self.nick, self.error_message = *params
      else
        self.error_message = params.first
      end
    end
  end
end

class IRCParser::Messages::Away < IRCParser::Message
  parameter :away_message
end

class IRCParser::Messages::Rehash < IRCParser::Message
end

class IRCParser::Messages::Restart < IRCParser::Message
end

class IRCParser::Messages::Summon < IRCParser::Message
  parameter :nick

  def servers
    parameters[1..-1]
  end

  def servers=(val)
    parameters.pop while parameters.length > 1
    Array(val).each { |server| parameters.push(val) }
  end
end

class IRCParser::Messages::Users < IRCParser::Message
  parameter :target
end

class IRCParser::Messages::WallOps < IRCParser::Message
  parameter :wall_message
end

module IRCParser::Messages::NickMan
  def nicks=(vals)
    parameters.replace(Array(vals))
  end

  def nicks
    parameters
  end
end

class IRCParser::Messages::UserHost < IRCParser::Message
  include IRCParser::Messages::NickMan
end

class IRCParser::Messages::IsOn < IRCParser::Message
  include IRCParser::Messages::NickMan
end
