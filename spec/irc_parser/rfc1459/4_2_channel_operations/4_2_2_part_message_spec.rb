require 'spec_helper'

describe IRCParser, "parsing part message" do

  it_parses "PART #twilight_zone" do |message|
    message.channels.should == ["#twilight_zone"]
  end

  it_parses "PART #oz-ops,&group5" do |message|
    message.channels.should == ["#oz-ops", "&group5"]
  end

  #-------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Part,  "PART #twilight_zone" do |message|
    message.channels= ["#twilight_zone"]
  end

  it_generates IRCParser::Messages::Part,  "PART #oz-ops,&group5" do |message|
    message.channels= ["#oz-ops", "&group5"]
  end

end
