require 'spec_helper'

describe IRCParser, "parsing names message" do

  # ; list visible users on #twilight_zone and #42 if the channels are visible to you.
  it_parses "NAMES #twilight_zone,#42" do |message|
    message.channels.should == ["#twilight_zone", "#42"]
  end

  # ; list all visible channels and users
  it_parses "NAMES" do |message|
    message.channels.should == []
  end

  #------------------------------------------------------------------------------

  # ; list visible users on #twilight_zone and #42 if the channels are visible to you.
  it_generates IRCParser::Messages::Names, "NAMES #twilight_zone,#42" do |message|
    message.channels= ["#twilight_zone", "#42"]
  end

  # ; list all visible channels and users
  it_generates IRCParser::Messages::Names, "NAMES" do |message|
    message.channels= []
  end
end
