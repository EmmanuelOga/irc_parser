require 'spec_helper'

describe IRCParser, "parsing error" do

  # ; ERROR msg to the other server which caused this error.
  it_parses "ERROR :Server *.fi already exists" do |msg|
    msg.error_message.should == "Server *.fi already exists"
  end

  # ; Same ERROR msg as above but sent to user WiZ on the other server.
  it_parses "NOTICE WiZ :ERROR from csd.bu.edu -- Server *.fi already exists" do |msg|
    msg.target.should == "WiZ"
    msg.body.should == "ERROR from csd.bu.edu -- Server *.fi already exists"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Error, "ERROR :Server *.fi already exists" do |msg|
    msg.error_message= "Server *.fi already exists"
  end

  it_generates IRCParser::Messages::Notice, "NOTICE WiZ :ERROR from csd.bu.edu -- Server *.fi already exists" do |msg|
    msg.target = "WiZ"
    msg.body = "ERROR from csd.bu.edu -- Server *.fi already exists"
  end
end
