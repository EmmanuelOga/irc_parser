require 'spec_helper'

describe IRCParser, "parsing error" do

  # ; ERROR message to the other server which caused this error.
  it_parses "ERROR :Server *.fi already exists" do |message|
    message.error_message.should == "Server *.fi already exists"
  end

  # ; Same ERROR message as above but sent to user WiZ on the other server.
  it_parses "NOTICE WiZ :ERROR from csd.bu.edu -- Server *.fi already exists" do |message|
    message.target.should == "WiZ"
    message.body.should == "ERROR from csd.bu.edu -- Server *.fi already exists"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Error, "ERROR :Server *.fi already exists" do |message|
    message.error_message= "Server *.fi already exists"
  end

  it_generates IRCParser::Messages::Notice, "NOTICE WiZ :ERROR from csd.bu.edu -- Server *.fi already exists" do |message|
    message.target = "WiZ"
    message.body = "ERROR from csd.bu.edu -- Server *.fi already exists"
  end
end
