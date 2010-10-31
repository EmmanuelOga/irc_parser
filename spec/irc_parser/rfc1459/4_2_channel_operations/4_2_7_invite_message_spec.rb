require 'spec_helper'

describe IRCParser, "parsing invite msg" do

  # ; User Angel inviting WiZ to channel #Dust
  it_parses ":Angel INVITE Wiz #Dust" do |msg|
    msg.channel.should == "#Dust"
    msg.prefix.should == "Angel"
    msg.to_nick.should == "Wiz"
  end

  # ; Command to invite WiZ to #Twilight_zone
  it_parses "INVITE Wiz #Twilight_Zone"  do |msg|
    msg.channel.should == "#Twilight_Zone"
    msg.prefix.should be_nil
    msg.to_nick.should == "Wiz"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Invite, ":Angel INVITE Wiz #Dust" do |msg|
    msg.channel= "#Dust"
    msg.prefix= "Angel"
    msg.to_nick= "Wiz"
  end

  it_generates IRCParser::Messages::Invite, "INVITE Wiz #Twilight_Zone"  do |msg|
    msg.channel= "#Twilight_Zone"
    msg.to_nick= "Wiz"
  end
end
