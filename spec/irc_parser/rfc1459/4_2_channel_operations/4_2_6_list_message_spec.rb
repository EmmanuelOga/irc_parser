require 'spec_helper'

describe IRCParser, "parsing list msg" do

  # ; List all channels.
  it_parses "LIST" do |msg|
    msg.channels.should == []
  end

  # ; List channels #twilight_zone and #42
  it_parses "LIST #twilight_zone,#42"  do |msg|
    msg.channels.should == ["#twilight_zone", "#42"]
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::List, "LIST" do |msg|
  end

  it_generates IRCParser::Messages::List, "LIST #twilight_zone,#42"  do |msg|
    msg.channels= ["#twilight_zone", "#42"]
  end
end
