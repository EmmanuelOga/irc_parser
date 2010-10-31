require 'spec_helper'

describe IRCParser, "parsing ping msg" do
  # Parameters: <target1> [<target2>]

  # ; target sending a PING msg to another target to indicate it is still alive.
  it_parses "PING tolsun.oulu.fi" do |msg|
    msg.target.should == "tolsun.oulu.fi"
  end

  it_parses "PING tolsun.oulu.fi other.com" do |msg|
    msg.target.should == "tolsun.oulu.fi"
    msg.final_target.should == "other.com"
  end

  # ; PING msg being sent to nick WiZ
  it_parses "PING WiZ" do |msg|
    msg.target.should == "WiZ"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Ping, "PING tolsun.oulu.fi" do |msg|
    msg.target= "tolsun.oulu.fi"
  end

  it_generates IRCParser::Messages::Ping, "PING tolsun.oulu.fi other.com" do |msg|
    msg.target= "tolsun.oulu.fi"
    msg.final_target= "other.com"
  end

  it_generates IRCParser::Messages::Ping, "PING WiZ" do |msg|
    msg.target= "WiZ"
  end
end
