require 'spec_helper'

describe IRCParser, "parsing connect message" do

  # ; Attempt to connect a server to tolsun.oulu.fi
  it_parses "CONNECT tolsun.oulu.fi" do |message|
    message.target_server.should == "tolsun.oulu.fi"
  end

  # ; CONNECT attempt by WiZ to get servers eff.org and csd.bu.edu connected on port 6667.
  it_parses ":WiZ CONNECT eff.org 6667 csd.bu.edu" do |message|
    message.prefix.should == "WiZ"
    message.target_server.should == "eff.org"
    message.port.should == "6667"
    message.remote_server.should == "csd.bu.edu"
  end

  #------------------------------------------------------------------------------

  # ; Attempt to connect a server to tolsun.oulu.fi
  it_generates IRCParser::Messages::Connect, "CONNECT tolsun.oulu.fi" do |message|
    message.target_server= "tolsun.oulu.fi"
  end

  # ; CONNECT attempt by WiZ to get servers eff.org and csd.bu.edu connected on port 6667.
  it_generates IRCParser::Messages::Connect, ":WiZ CONNECT eff.org 6667 csd.bu.edu" do |message|
    message.prefix= "WiZ"
    message.target_server= "eff.org"
    message.port= "6667"
    message.remote_server= "csd.bu.edu"
  end
end
