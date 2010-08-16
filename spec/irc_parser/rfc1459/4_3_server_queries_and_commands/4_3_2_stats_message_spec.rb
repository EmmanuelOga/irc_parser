require 'spec_helper'

describe IRCParser, "parsing stats message" do

  # ; check the command usage for the server you are connected to
  it_parses "STATS m" do |message|
    message.prefix.should be_nil
    message.mode.should == "m"
    message.server.should be_nil
  end

  # ; request by WiZ for C/N line information from server eff.org
  it_parses ":Wiz STATS c eff.org" do |message|
    message.prefix.should == "Wiz"
    message.mode.should == "c"
    message.server.should == "eff.org"
  end

  #------------------------------------------------------------------------------

  # ; check the command usage for the server you are connected to
  it_generates IRCParser::Messages::Stats, "STATS m" do |message|
    message.mode= "m"
  end

  # ; request by WiZ for C/N line information from server eff.org
  it_generates IRCParser::Messages::Stats, ":Wiz STATS c eff.org" do |message|
    message.prefix= "Wiz"
    message.mode= "c"
    message.server= "eff.org"
  end
end
