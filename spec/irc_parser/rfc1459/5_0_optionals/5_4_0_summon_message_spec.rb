require 'spec_helper'

describe IRCParser, "parsing summon message" do
  # Parameters: <user> [<server>]

  # ; summon user jto on the server's host
  it_parses "SUMMON jto" do |message|
    message.nick.should == "jto"
    message.servers.should be_empty
  end

  # ; summon user jto on the host which a server named "tolsun.oulu.fi" is running.
  it_parses "SUMMON jto tolsun.oulu.fi"  do |message|
    message.nick.should == "jto"
    message.servers.should == ["tolsun.oulu.fi"]
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Summon, "SUMMON jto" do |message|
    message.nick= "jto"
    message.servers.should be_empty
  end

  it_generates IRCParser::Messages::Summon, "SUMMON jto tolsun.oulu.fi"  do |message|
    message.nick= "jto"
    message.servers= ["tolsun.oulu.fi"]
  end
end
