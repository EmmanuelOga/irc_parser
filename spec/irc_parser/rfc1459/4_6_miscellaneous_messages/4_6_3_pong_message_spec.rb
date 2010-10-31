require 'spec_helper'

describe IRCParser, "parsing pong msg" do
  # Parameters: <daemon> [<daemon2>]

  it_parses "PONG irc.test.host" do |msg|
    msg.server.should == "irc.test.host"
  end

  # ; PONG msg from csd.bu.edu to tolsun.oulu.fi
  it_parses "PONG csd.bu.edu tolsun.oulu.fi"  do |msg|
    msg.server.should == "csd.bu.edu"
    msg.target.should == "tolsun.oulu.fi"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Pong, "PONG irc.test.host" do |msg|
    msg.server= "irc.test.host"
  end

  it_generates IRCParser::Messages::Pong, "PONG csd.bu.edu tolsun.oulu.fi"  do |msg|
    msg.server= "csd.bu.edu"
    msg.target= "tolsun.oulu.fi"
  end
end
