require 'spec_helper'

describe IRCParser, "parsing part msg" do

  it_parses "PART #twilight_zone" do |msg|
    msg.channels.should == ["#twilight_zone"]
  end

  it_parses "PART #oz-ops,&group5" do |msg|
    msg.channels.should == ["#oz-ops", "&group5"]
  end

  #-------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Part,  "PART #twilight_zone" do |msg|
    msg.channels= ["#twilight_zone"]
  end

  it_generates IRCParser::Messages::Part,  "PART #oz-ops,&group5" do |msg|
    msg.channels= ["#oz-ops", "&group5"]
  end

end
