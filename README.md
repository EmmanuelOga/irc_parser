# IRCParser

A ruby 1.9.x parser for IRC messages which includes commands, errors and
replies classese according to the IRC RFCs definitions.

This library does not deal at all with networking.

## Goals

In every irc library I've seen people implement the various irc messages
again and again.

IRCParser tackles that boring task so the hard work in making the RFC
compliant IRC messages can be shared across projects.

This gem does _not_ provide an irc server, and irc client or a DSL to
implement IRC bots, etc.

## Parsing Messages

The parser can be run so it returns the raw components of an irc message
([prefix, command, *params]), or an specific class for each kind of
message constructed from those parts.

The parser is quite strict so it will expect the IRC delimiters in all
messages to parse (i.e. all messages must end with '\r\n').

```ruby
  require 'irc_parser'
  IRCParser::Parser.run(":Angel PRIVMSG Wiz :Hello are you receiving this message?\r\n") # notice final \r\n
  # => ["Angel", "PRIVMSG", "Wiz", "Hello are you receiving this message ?"]
```

And, to get a subclass of IRCParser::Message instead of an array of
components:

```ruby
  require 'irc_parser/messages'
  msg = IRCParser.parse(":Angel PRIVMSG Wiz :Hello are you receiving this message?\r\n")
  # <IRCParser::Messages::Privmsg:0x00000001476370 @params=["Wiz", "Hello are you receiving this message?"], @prefix="Angel">

  msg.identifier # => "PRIVMSG"
  msg.to_sym     # => :priv_msg
  msg.prefix     # => "Angel"
  msg.params     # => ["Wiz", "Hello are you receiving this message?"]
  msg.from       # => "Angel"
  msg.target     # => "Wiz"
  msg.body       # => "Hello are you receiving this message?"
```

## Generating Messages

```ruby
  msg = IRCParser::Messages::PrivMsg.new
  msg.from   = "Wiz"
  msg.target = "Angel"
  msg.body   = "Hello World!"
  msg.to_s   # => ":Wiz PRIVMSG Angel :Hello World!\r\n"
```

There is also a shortcut:

```ruby
  require 'irc_parser/messages'
  msg = IRCParser.message(:privmsg) do |m|
    msg.from   = "Wiz"
    msg.target = "Angel"
    msg.body   = "Hello World!"
  end
  msg.to_s # => ":Wiz PRIVMSG Angel :Hello World!\r\n"
```

## TODO

* Documentation!
* It would be nice to add support for parsing/generating extended mirc
  messages.
* Most severs/clients do not implement the messages exactly as defined
  on the RFCs (sometimes http://www.mirc.net/raws/ was used as
  reference). So, some messages may require adjustments to be usable
  in the wild.
* 1459 compliant, with some of the messages updated to the rfc 2812.
  Fixes/updates are warmly welcome!

## AUTHORS

A lot of projects where reviewed while implementing this library.  I may
or may not have stolen something from one of these, although I'm the
only one to blame for the contents of this gem. If I forget about anyone
please ping me so I can include you here.

* Ragel parser and other portions where taken from irk (brodock/irk)
