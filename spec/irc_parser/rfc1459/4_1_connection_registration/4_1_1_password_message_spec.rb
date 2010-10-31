require 'spec_helper'

describe IRCParser, "parsing password msg" do

  it_parses "PASS secretpasswordhere" do |msg|
    msg.password.should == "secretpasswordhere"
  end

  it_parses "PASS" do |msg|
    msg.password.should == nil
  end

  it_parses "PASS :" do |msg|
    msg.password.should == ""
  end

  it_generates IRCParser::Messages::Pass, "PASS" do |msg|
    msg.password = ""
  end

  it_generates IRCParser::Messages::Pass, "PASS" do |msg|
    msg.password = nil
  end

  it_generates IRCParser::Messages::Pass, "PASS secretpasswordhere" do |msg|
    msg.password = "secretpasswordhere"
  end
end
