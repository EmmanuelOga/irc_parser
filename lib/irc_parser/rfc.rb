module IRCParser
  module RFC
    extend self

    def parse_regexp(text)
      /#{ text.to_s.split(".").join("\\.").gsub(/\*|\?/, ".*") }/
    end

    # http://tools.ietf.org/html/rfc1459#section-4.3.2
    # c - returns a list of servers which the server may connect to or allow connections from;
    # h - returns a list of servers which are either forced to be treated as leaves or allowed to act as hubs;
    # i - returns a list of hosts which the server allows a client to connect from;
    # k - returns a list of banned username/hostname combinations for that server;
    # l - returns a list of the server's connections, showing how long each connection has been established and the traffic
    #     over that connection in bytes and messages for each direction;
    # m - returns a list of commands supported by the server and the usage count for each if the usage count is non zero;
    # o - returns a list of hosts from which normal clients may become operators;
    # y - show Y (Class) lines from server's configuration file;
    # u - returns a string showing how long the server has been up.
    STATS_MODES = %w|c h i k l m o y u|

    NICK_REGEXP = /^[a-zA-Z]+[a-zA-Z0-9]*/

    def valid_nick?(nick)
      nick =~ NICK_REGEXP
    end

    def invalid_nick?(nick)
      not valid_nick?(nick)
    end

    module NicknameHelpers
      %w|valid_nick? invalid_nick?|.each do |meth|
        define_method(meth) { IRCParser::RFC.send(meth, self) }
      end
    end

    CHANNEL_PREFIXES = {
      :normal   => "#",
      :local    => "&",
      :modeless => "+",
      :safe     => "!"
    }

    CHANNEL_REGEXP = /^[#{CHANNEL_PREFIXES.values.join("|")}][a-zA-Z0-9]+/

    def valid_channel_name?(name)
      name.to_s =~ CHANNEL_REGEXP
    end

    def invalid_channel_name?(name)
      not valid_channel_name?(name)
    end

    CHANNEL_PREFIXES.each do |channel_mode, prefix|
      define_method("#{channel_mode}_channel?") do |name|
        name.to_s[0, 1] == prefix
      end
    end

    module ChannelHelpers
      (CHANNEL_PREFIXES.keys.map {|mode| "#{mode}_channel?" } + %w|valid_channel_name? invalid_channel_name?|).each do |meth|
        define_method(meth) { IRCParser::RFC.send(meth, self) }
      end
    end
  end
end
