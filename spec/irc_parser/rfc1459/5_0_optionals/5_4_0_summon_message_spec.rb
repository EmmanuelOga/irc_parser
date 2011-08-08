require 'spec_helper'

describe IRCParser, "parsing summon msg" do
  # Parameters: <user> [<server>]

  # ; summon user jto on the server's host
  it_parses "SUMMON jto" do |msg|
    msg.nick.should == "jto"
    msg.server.should be_nil
  end

  # ; summon user jto on the host which a server named "tolsun.oulu.fi" is running.
  it_parses "SUMMON jto tolsun.oulu.fi"  do |msg|
    msg.nick.should == "jto"
    msg.server.should == "tolsun.oulu.fi"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Summon, "SUMMON jto" do |msg|
    msg.nick= "jto"
  end

  it_generates IRCParser::Messages::Summon, "SUMMON jto tolsun.oulu.fi"  do |msg|
    msg.nick= "jto"
    msg.server= "tolsun.oulu.fi"
  end
end
