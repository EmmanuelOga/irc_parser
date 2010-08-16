require 'spec_helper'

describe IRCParser, "parsing ping message" do
  # Parameters: <target1> [<target2>]

  # ; target sending a PING message to another target to indicate it is still alive.
  it_parses "PING tolsun.oulu.fi" do |message|
    message.target.should == "tolsun.oulu.fi"
  end

  it_parses "PING tolsun.oulu.fi other.com" do |message|
    message.target.should == "tolsun.oulu.fi"
    message.final_target.should == "other.com"
  end

  # ; PING message being sent to nick WiZ
  it_parses "PING WiZ" do |message|
    message.target.should == "WiZ"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Ping, "PING tolsun.oulu.fi" do |message|
    message.target= "tolsun.oulu.fi"
  end

  it_generates IRCParser::Messages::Ping, "PING tolsun.oulu.fi other.com" do |message|
    message.target= "tolsun.oulu.fi"
    message.final_target= "other.com"
  end

  it_generates IRCParser::Messages::Ping, "PING WiZ" do |message|
    message.target= "WiZ"
  end
end
