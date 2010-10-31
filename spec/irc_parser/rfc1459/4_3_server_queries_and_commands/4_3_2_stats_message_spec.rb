require 'spec_helper'

describe IRCParser, "parsing stats msg" do

  # ; check the command usage for the server you are connected to
  it_parses "STATS m" do |msg|
    msg.prefix.should be_nil
    msg.mode.should == "m"
    msg.server.should be_nil
  end

  # ; request by WiZ for C/N line information from server eff.org
  it_parses ":Wiz STATS c eff.org" do |msg|
    msg.prefix.should == "Wiz"
    msg.mode.should == "c"
    msg.server.should == "eff.org"
  end

  #------------------------------------------------------------------------------

  # ; check the command usage for the server you are connected to
  it_generates IRCParser::Messages::Stats, "STATS m" do |msg|
    msg.mode= "m"
  end

  # ; request by WiZ for C/N line information from server eff.org
  it_generates IRCParser::Messages::Stats, ":Wiz STATS c eff.org" do |msg|
    msg.prefix= "Wiz"
    msg.mode= "c"
    msg.server= "eff.org"
  end
end
