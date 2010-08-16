require 'spec_helper'

describe IRCParser, "parsing pong message" do
  # Parameters: <daemon> [<daemon2>]

  it_parses "PONG irc.test.host" do |message|
    message.server.should == "irc.test.host"
  end

  # ; PONG message from csd.bu.edu to tolsun.oulu.fi
  it_parses "PONG csd.bu.edu tolsun.oulu.fi"  do |message|
    message.server.should == "csd.bu.edu"
    message.target.should == "tolsun.oulu.fi"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Pong, "PONG irc.test.host" do |message|
    message.server= "irc.test.host"
  end

  it_generates IRCParser::Messages::Pong, "PONG csd.bu.edu tolsun.oulu.fi"  do |message|
    message.server= "csd.bu.edu"
    message.target= "tolsun.oulu.fi"
  end
end
