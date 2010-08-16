module IRCParser::Messages::RemoveExtraWildcards
  def process_parameters(params)
    params.remove_placeholders
  end
end

IRCParser::Messages::Message.define_message :Join do
  param_means :channels, :index => 0, :csv => true
  param_means :keys, :index => 1, :csv => true
end

IRCParser::Messages::Message.define_message :Mode do
  include IRCParser::Messages::RemoveExtraWildcards

  param_means :channel,  :index => 0, :aliases => [:nick]
  param_means :flags,    :index => 1, :default => ""
  param_means :limit,    :index => 2, :aliases => [:key]
  param_means :user,     :index => 3
  param_means :ban_mask, :index => 4

  # Damned rfc.
  # Channel Parameters: <channel> {[+|-]|o|p|s|i|t|n|b|v} [<limit>] [<user>] [<ban mask>]
  # User Parameters: <nickname> {[+|-]|i|w|s|o}
  def initialize_params(vals)
    if vals.length == 5 || vals.length == 2
      vals.each_with_index { |val, index| params[index] = val }
    else
      self.channel = vals[0]
      self.flags = vals[1]

      if remaining = vals[2..-1]
        if remaining.first =~ /\d+/ || self.flags =~ /\+k/
          self.limit = remaining.shift
        elsif self.flags =~ /\+b/
          self.ban_mask = remaining.first
        else
          self.user, self.ban_mask = *remaining
          self.ban_mask = IRCParser::Params::PLACEHOLDER if self.ban_mask.nil?
        end
      end
    end

    self.flags = self.flags ? self.flags.downcase : ""
  end

  def for_channel?
    IRCParser::RFC.valid_channel_name?(params.first.to_s)
  end

  def for_user?
    IRCParser::RFC.valid_nick?(params.first.to_s)
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
    flags[0,1] == "-"
  end

  def positive_flags?
    not negative_flags?
  end

  def negative_flags!
    case flags[0,1]
    when "-" then # Do nothing
    when "+" then self.flags[0] = "-"
    else
      self.flags.insert(0, "-") # Should not happen. Anyway.
    end
  end

  def positive_flags!
    case flags[0,1]
    when "+" then # Do nothing
    when "-" then self.flags[0] = "+"
    else
      self.flags.insert(0, "+") # Should not happen. Anyway.
    end
  end

  CHANNEL_MODES.each do |name, flag|
    define_method("chan_flags_include_#{name}?") do
      for_channel? && flags.include?(flag)
    end

    define_method("chan_#{name}?") do
      for_channel? && flags.include?(flag) && positive_flags?
    end

    define_method("chan_#{name}!") do
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
      for_user? && flags.include?(flag)
    end

    define_method("user_#{name}?") do
      for_user? && flags.include?(flag) && positive_flags?
    end

    define_method("user_#{name}!") do
      self.flags = flags + flag unless self.flags.include?(flag)
    end
  end
end

IRCParser::Messages::Message.define_message :Nick do
  param_means :nick, :index => 0
  param_means :hopcount, :index => 1 # removed in RFC 2812

  def invalid_nick?
    IRCParser::RFC.invalid_nick?(nick)
  end

  def changing?
    from.to_s =~ /\S/
  end
end

IRCParser::Messages::Message.define_message :Oper do
  param_means :user, :index => 0
  param_means :password, :index => 1
end

IRCParser::Messages::Message.define_message :Part do
  param_means :channels, :index => 0, :csv => true
  param_means :part_message, :index => 1
end

IRCParser::Messages::Message.define_message :Pass do
  param_means :password, :index => 0
end

IRCParser::Messages::Message.define_message :Quit do
  param_means :quit_message, :index => 0
end

IRCParser::Messages::Message.define_message :Server do
  param_means :server, :index => 0
  param_means :hopcount, :index => 1
  param_means :info, :index => 2

  def hopcount
    params[1].to_i
  end

  # not sure about this one, from RFC 2813
  # http://tools.ietf.org/html/rfc2813#section-4.1.2
  def token
    params[3] if params.length == 4
  end

end

IRCParser::Messages::Message.define_message :Squit do
  param_means :server, :index => 0
  param_means :reason, :index => 1
end

IRCParser::Messages::Message.define_message :Topic do
  include IRCParser::Messages::RemoveExtraWildcards

  param_means :channel, :index => 0
  param_means :topic, :index => 1
end

IRCParser::Messages::Message.define_message :User do
  param_means :user, :index => 0
  param_means :mode, :index => 1, :aliases => [:hostname] # rfc 1459, deprecated
  param_means :unused, :index => 2, :aliases => [:servername] # rfc 1459, deprecated
  param_means :real_name, :index => 3
end

IRCParser::Messages::Message.define_message :Names do
  param_means :channels, :index => 0, :csv => true
end

IRCParser::Messages::Message.define_message :List do
  param_means :channels, :index => 0, :csv => true
end

IRCParser::Messages::Message.define_message :Invite do
  param_means :to_nick, :index => 0
  param_means :channel, :index => 1
end

IRCParser::Messages::Message.define_message :Kick do
  include IRCParser::Messages::RemoveExtraWildcards

  param_means :channels, :index => 0, :csv => true
  param_means :users,    :index => 1, :csv => true
  param_means :kick_message,  :index => 2
end

IRCParser::Messages::Message.define_message :Version do
  param_means :server, :index => 0
end

IRCParser::Messages::Message.define_message :Stats do
  param_means :mode, :index => 0
  param_means :server, :index => 1
end

IRCParser::Messages::Message.define_message :Links do
  include IRCParser::Messages::RemoveExtraWildcards

  param_means :remote_server, :index => 0
  param_means :server_mask, :index => 1

  def initialize_params(vals)
    case vals.length
    when 1 then self.server_mask = vals.first
    when 2 then self.remote_server, self.server_mask = *vals
    end
  end
end

IRCParser::Messages::Message.define_message :Time do
  param_means :for_server, :index => 0
end

IRCParser::Messages::Message.define_message :Connect do
  param_means :target_server, :index => 0
  param_means :port, :index => 1
  param_means :remote_server, :index => 2

  def initialize_params(vals)
    case vals.length
    when 1 then self.target_server = vals.first
    when 2 then self.target_server, self.remote_server = *vals
    when 3 then self.target_server, self.port, self.remote_server = *vals
    end
  end
end

IRCParser::Messages::Message.define_message :Trace do
  param_means :server, :index => 0

  # synonims.. if to_nick is found on the list of nicks it is a nick, else it is a server.
  param_means :to_nick, :index => 0
end

IRCParser::Messages::Message.define_message :Admin do
  param_means :server, :index => 0
end

IRCParser::Messages::Message.define_message :Info do
  param_means :server, :index => 0

  # synonims.. if to_nick is found on the list of nicks it is a nick, else it is a server.
  param_means :server_for_nick, :index => 0
end

IRCParser::Messages::Message.define_message :Privmsg, :Notice do
  param_means :target, :index => 0
  param_means :body, :index => 1

  def for_channel?
    IRCParser::RFC.valid_channel_name?(target.to_s)
  end

  def for_user?
    IRCParser::RFC.valid_nick?(target.to_s)
  end

  def for_server_pattern?
    target.to_s =~ /^\$/
  end

  def for_host_pattern?
    target.to_s =~ /^\#/
  end

  def server_pattern
    for_server_pattern? && RFC::parse_regexp(params.first[1..-1])
  end

  def host_pattern
    for_host_pattern? && RFC::parse_regexp(params.first[1..-1])
  end

  alias_method :server_pattern=, :target=
  alias_method :host_pattern=, :target=
end

IRCParser::Messages::Message.define_message :Who do
  param_means :pattern, :index => 0, :aliases => [:channel]
  param_means :operator, :index => 1

  alias_method :operator?, :operator

  def for_channel?
    IRCParser::RFC.valid_channel_name?(channel)
  end

  def operator!(true_or_false = true)
    self.operator = true_or_false ? "o" : ""
  end

  def regexp
    IRCParser::RFC.parse_regexp(pattern)
  end
end

IRCParser::Messages::Message.define_message :Whois do
  include IRCParser::Messages::RemoveExtraWildcards

  param_means :target, :index => 0
  param_means :pattern, :index => 1

  def initialize_params(vals)
    if vals.length == 2
      self.target, self.pattern = *vals
    else
      self.pattern = vals.first
    end
  end

  def regexp
    IRCParser::RFC.parse_regexp(pattern)
  end
end

IRCParser::Messages::Message.define_message :Kill do
  param_means :nick, :index => 0
  param_means :kill_message, :index => 1
end

IRCParser::Messages::Message.define_message :Whowas do
  param_means :nick, :index => 0
  param_means :count, :index => 1
  param_means :server, :index => 2

  def count
    params[1].to_i
  end
end

IRCParser::Messages::Message.define_message :Ping do
  param_means :target, :index => 0
  param_means :final_target, :index => 1
end

IRCParser::Messages::Message.define_message :Pong do
  param_means :server, :index => 0
  param_means :target, :index => 1
end

IRCParser::Messages::Message.define_message :Error do
  include IRCParser::Messages::RemoveExtraWildcards

  param_means :nick, :index => 0
  param_means :error_message, :index => 1

  def initialize_params(vals)
    if vals.length == 2
      self.nick, self.error_message = *vals
    else
      self.error_message = vals.first
    end
  end
end

IRCParser::Messages::Message.define_message :Away do
  param_means :away_message, :index => 0
end

IRCParser::Messages::Message.define_message :Rehash, :Restart

IRCParser::Messages::Message.define_message :Summon do
  param_means :nick, :index => 0

  def servers
    params[1..-1]
  end

  def servers=(val)
    params.pop while params.length > 1
    Array(val).each { |server| params.push(val) }
  end
end

IRCParser::Messages::Message.define_message :Users do
  param_means :of_server, :index => 0
end

IRCParser::Messages::Message.define_message :Wallops do
  param_means :wall_message, :index => 0
end

IRCParser::Messages::Message.define_message :Userhost, :Ison do
  def nicks=(vals)
    params.clear
    Array(vals).each { |val| params.push(val) }
  end

  def nicks
    params.dup
  end

  def add_nick(val)
    params.push(val)
  end
end
