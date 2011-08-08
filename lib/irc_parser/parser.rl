%%{
  machine irc_parser;

  NUL = '\0';
  BELL = '\a';
  CR = '\r';
  LF = '\n';
  SPACE = ' '+;

  crlf = CR LF;
  comma = ',';
  nonwhite = ascii -- (SPACE | NUL | CR | LF);
  special = ('_' | '-' | '[' | ']' | '\\' | '`' | '^' | '{' | '}' | '~');

  # unicode sequences taken from Wincent.com 's wikitext
  # http://git.wincent.com/wikitext.git/blob/HEAD:/ext/wikitext_ragel.rl#l459
  unicode = (0x01..0x1f | 0x7f)                         |
            (0xc2..0xdf 0x80..0xbf)                     |
            (0xe0..0xef 0x80..0xbf 0x80..0xbf)          |
            (0xf0..0xf4 0x80..0xbf 0x80..0xbf 0x80..0xbf);

  chstring = ascii -- (SPACE | BELL | NUL | CR | LF | comma);
  mask = ('#' | '$') chstring;
  nick = alpha (alpha | digit | special)*;
  host = (alpha | digit | '-' | '.')+;
  servername = host;
  channel = ('#' | '&') chstring;
  user = nonwhite+;
  to_ = channel | (user '@' servername) | nick | mask;
  target = to_ (',' to_)*;

  action mark { mark = p }
  action prefix { prefix = data[mark..(p-1)].pack("c*") }
  action command { command = data[mark..(p-1)].pack("c*") }
  action params { params << data[mark..(p-1)].pack("c*") }

  trailing = ( ( ascii | unicode ) -- (NUL | CR | LF) )* >mark %params;
  middle = ( (nonwhite - ':') nonwhite* ) >mark %params;
  params = SPACE? (SPACE middle)* (SPACE ':' trailing)?;
  command = (alpha+ | digit digit digit) >mark %command;
  prefix = (servername | nick ('!' user)? ('@' host)?) >mark %prefix;
  message = (':' prefix SPACE)? command params crlf;

  main := message;
}%%

module IRCParser
  class ParserError < RuntimeError; end

  %% write data;

  CLASS_FROM_PARSE = Hash.new { |h,k| h[k] = Messages::ALL[k] } # This hash will be smaller than Messages::ALL, and hence faster.

  def parse(message)
    data = message.unpack("c*")

    prefix, command, params = nil, nil, []

    %% write init;
    %% write exec;

    if cs >= irc_parser_first_final
      klass = CLASS_FROM_PARSE[command]
      raise ParserError, "Message not recognized: #{message.inspect}" unless klass
      klass.new(prefix, params)
    elsif message !~ /\r\n$/
      raise ParserError, "Message must finish with \\r\\n"
    else
      raise ParserError, message
    end
  end

  def parse_raw(message)
    data = message.unpack("c*")

    prefix, command, params = nil, nil, []

    %% write init;
    %% write exec;

    if cs >= irc_parser_first_final
      return prefix, command, params
    elsif message !~ /\r\n$/
      raise ParserError, "Message must finish with \\r\\n"
    else
      raise ParserError, message
    end
  end
end
