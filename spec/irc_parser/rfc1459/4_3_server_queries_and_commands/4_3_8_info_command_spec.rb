require 'spec_helper'

describe IRCParser, "parsing info command" do

  # ; request an INFO reply from csd.bu.edu
  it_parses "INFO csd.bu.edu" do |message|
    message.server.should == "csd.bu.edu"
  end

  # ; INFO request from Avalon for first server found to match *.fi.
  it_parses ":Avalon INFO *.fi" do |message|
    message.prefix.should == "Avalon"
    message.server.should == "*.fi"
  end

  # ; request info from the server that Angel is connected to.
  it_parses "INFO Angel" do |message|
    message.server_for_nick.should == "Angel"
  end

  #------------------------------------------------------------------------------

  # ; request an INFO reply from csd.bu.edu
  it_generates IRCParser::Messages::Info, "INFO csd.bu.edu" do |message|
    message.server= "csd.bu.edu"
  end

  # ; INFO request from Avalon for first server found to match *.fi.
  it_generates IRCParser::Messages::Info, ":Avalon INFO *.fi" do |message|
    message.prefix= "Avalon"
    message.server= "*.fi"
  end

  # ; request info from the server that Angel is connected to.
  it_generates IRCParser::Messages::Info, "INFO Angel" do |message|
    message.server_for_nick= "Angel"
  end
end
