require 'spec_helper'

describe IRCParser, "parsing connect msg" do

  # ; Attempt to connect a server to tolsun.oulu.fi
  it_parses "CONNECT tolsun.oulu.fi" do |msg|
    msg.target_server.should == "tolsun.oulu.fi"
  end

  # ; CONNECT attempt by WiZ to get servers eff.org and csd.bu.edu connected on port 6667.
  it_parses ":WiZ CONNECT eff.org 6667 csd.bu.edu" do |msg|
    msg.prefix.should == "WiZ"
    msg.target_server.should == "eff.org"
    msg.port.should == "6667"
    msg.remote_server.should == "csd.bu.edu"
  end

  #------------------------------------------------------------------------------

  # ; Attempt to connect a server to tolsun.oulu.fi
  it_generates IRCParser::Messages::Connect, "CONNECT tolsun.oulu.fi" do |msg|
    msg.target_server= "tolsun.oulu.fi"
  end

  # ; CONNECT attempt by WiZ to get servers eff.org and csd.bu.edu connected on port 6667.
  it_generates IRCParser::Messages::Connect, ":WiZ CONNECT eff.org 6667 csd.bu.edu" do |msg|
    msg.prefix= "WiZ"
    msg.target_server= "eff.org"
    msg.port= "6667"
    msg.remote_server= "csd.bu.edu"
  end
end
