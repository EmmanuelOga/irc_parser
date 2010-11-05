require 'spec_helper'

describe IRCParser, "parsing info command" do

  # ; request an INFO reply from csd.bu.edu
  it_parses "INFO csd.bu.edu" do |msg|
    msg.target.should == "csd.bu.edu"
  end

  # ; INFO request from Avalon for first target found to match *.fi.
  it_parses ":Avalon INFO *.fi" do |msg|
    msg.prefix.should == "Avalon"
    msg.target.should == "*.fi"
  end

  # ; request info from the target that Angel is connected to.
  it_parses "INFO Angel" do |msg|
    msg.target.should == "Angel"
  end

  #------------------------------------------------------------------------------

  # ; request an INFO reply from csd.bu.edu
  it_generates IRCParser::Messages::Info, "INFO csd.bu.edu" do |msg|
    msg.target= "csd.bu.edu"
  end

  # ; INFO request from Avalon for first target found to match *.fi.
  it_generates IRCParser::Messages::Info, ":Avalon INFO *.fi" do |msg|
    msg.prefix= "Avalon"
    msg.target= "*.fi"
  end

  # ; request info from the target that Angel is connected to.
  it_generates IRCParser::Messages::Info, "INFO Angel" do |msg|
    msg.target= "Angel"
  end
end
