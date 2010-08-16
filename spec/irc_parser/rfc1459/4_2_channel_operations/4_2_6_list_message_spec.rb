require 'spec_helper'

describe IRCParser, "parsing list message" do

  # ; List all channels.
  it_parses "LIST" do |message|
    message.channels.should == []
  end

  # ; List channels #twilight_zone and #42
  it_parses "LIST #twilight_zone,#42"  do |message|
    message.channels.should == ["#twilight_zone", "#42"]
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::List, "LIST" do |message|
    message.channels= []
  end

  it_generates IRCParser::Messages::List, "LIST #twilight_zone,#42"  do |message|
    message.channels= ["#twilight_zone", "#42"]
  end
end
