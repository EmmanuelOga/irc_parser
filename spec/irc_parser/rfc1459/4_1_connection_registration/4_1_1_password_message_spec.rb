require 'spec_helper'

describe IRCParser, "parsing password message" do

  it_parses "PASS secretpasswordhere" do |message|
    message.password.should == "secretpasswordhere"
  end

  it_parses "PASS" do |message|
    message.password.should == nil
  end

  it_parses "PASS :" do |message|
    message.password.should == ""
  end

  it_generates IRCParser::Messages::Pass, "PASS" do |message|
    message.password = ""
  end

  it_generates IRCParser::Messages::Pass, "PASS" do |message|
    message.password = nil
  end

  it_generates IRCParser::Messages::Pass, "PASS secretpasswordhere" do |message|
    message.password = "secretpasswordhere"
  end
end
