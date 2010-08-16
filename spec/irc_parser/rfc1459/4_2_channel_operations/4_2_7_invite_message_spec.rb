require 'spec_helper'

describe IRCParser, "parsing invite message" do

  # ; User Angel inviting WiZ to channel #Dust
  it_parses ":Angel INVITE Wiz #Dust" do |message|
    message.channel.should == "#Dust"
    message.prefix.should == "Angel"
    message.to_nick.should == "Wiz"
  end

  # ; Command to invite WiZ to #Twilight_zone
  it_parses "INVITE Wiz #Twilight_Zone"  do |message|
    message.channel.should == "#Twilight_Zone"
    message.prefix.should be_nil
    message.to_nick.should == "Wiz"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Invite, ":Angel INVITE Wiz #Dust" do |message|
    message.channel= "#Dust"
    message.prefix= "Angel"
    message.to_nick= "Wiz"
  end

  it_generates IRCParser::Messages::Invite, "INVITE Wiz #Twilight_Zone"  do |message|
    message.channel= "#Twilight_Zone"
    message.to_nick= "Wiz"
  end
end
