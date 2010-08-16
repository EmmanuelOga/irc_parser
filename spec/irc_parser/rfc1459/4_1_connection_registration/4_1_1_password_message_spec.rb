require 'spec_helper'

describe IRCParser, "parsing password message" do

  it_parses "PASS secretpasswordhere" do |message|
    message.password.should == "secretpasswordhere"
  end

  it_generates IRCParser::Messages::Pass, "PASS secretpasswordhere" do |message|
    message.password = "secretpasswordhere"
  end
end
