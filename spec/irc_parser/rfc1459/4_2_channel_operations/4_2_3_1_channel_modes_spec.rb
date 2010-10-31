require 'spec_helper'

describe IRCParser, "parsing channel modes" do

  # ; Makes #Finnish channel moderated and 'invite-only'.
  it_parses "MODE #Finnish +im" do |msg|
    msg.channel.should == "#Finnish"
    msg.user.should be_nil

    msg.flags.should == "+im"
    msg.should be_chan_flags_include_invite_only
    msg.should be_chan_invite_only
    msg.should be_chan_flags_include_moderated
    msg.should be_chan_moderated
  end

  # ; Gives 'chanop' privileges to Kilroy on channel #Finnish.
  it_parses "MODE #Finnish +o Kilroy" do |msg|
    msg.channel.should == "#Finnish"
    msg.user.should == "Kilroy"

    msg.flags.should == "+o"
    msg.should be_chan_flags_include_operator
    msg.should be_chan_operator
  end

  # ; Allow WiZ to speak on #Finnish.
  it_parses "MODE #Finnish +v Wiz" do |msg|
    msg.channel.should == "#Finnish"
    msg.user.should == "Wiz"

    msg.flags.should == "+v"
    msg.should be_chan_flags_include_speaker
    msg.should be_chan_speaker
  end

  # ; Removes 'secret' flag from channel #Fins.
  it_parses "MODE #Fins -s" do |msg|
    msg.channel.should == "#Fins"
    msg.user.should be_nil

    msg.flags.should == "-s"
    msg.should be_chan_flags_include_secret
    msg.should_not be_chan_secret
  end

  # ; Set the channel key to "oulu".
  it_parses "MODE #42 +k oulu" do |msg|
    msg.channel.should == "#42"
    msg.key.should == "oulu"

    msg.flags.should == "+k"
    msg.should be_chan_flags_include_password
    msg.should be_chan_password
  end

  # ; Set the limit for the number of users on channel to 10.
  it_parses "MODE #eu-opers +l 10" do |msg|
    msg.channel.should == "#eu-opers"
    msg.limit.should == "10"

    msg.flags.should == "+l"
    msg.should be_chan_flags_include_users_limit
    msg.should be_chan_users_limit
  end

  # ; list ban masks set for channel.
  it_parses "MODE &oulu +b" do |msg|
    msg.channel.should == "&oulu"
    msg.limit.should be_nil

    msg.flags.should == "+b"
    msg.should be_chan_flags_include_ban_mask
    msg.should be_chan_ban_mask
  end

  # ; prevent all users from joining.
  it_parses "MODE &oulu +b *!*@*" do |msg|
    msg.channel.should == "&oulu"
    msg.ban_mask.should == "*!*@*"

    msg.flags.should == "+b"
    msg.should be_chan_flags_include_ban_mask
    msg.should be_chan_ban_mask
  end

  # ; prevent any user from a hostname matching *.edu from joining.
  it_parses "MODE &oulu +b *!*@*.edu" do |msg|
    msg.channel.should == "&oulu"
    msg.ban_mask.should == "*!*@*.edu"

    msg.flags.should == "+b"
    msg.should be_chan_flags_include_ban_mask
    msg.should be_chan_ban_mask
  end

  #-------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Mode, "MODE #Finnish +im" do |msg|
    msg.channel= "#Finnish"
    msg.positive_flags!
    msg.chan_invite_only!
    msg.chan_moderated!
  end

  it_generates IRCParser::Messages::Mode, "MODE #Finnish +o Kilroy" do |msg|
    msg.channel= "#Finnish"
    msg.user= "Kilroy"
    msg.positive_flags!
    msg.chan_operator!
  end

  it_generates IRCParser::Messages::Mode, "MODE #Finnish +v Wiz" do |msg|
    msg.channel= "#Finnish"
    msg.user= "Wiz"
    msg.positive_flags!
    msg.chan_speaker!
  end

  it_generates IRCParser::Messages::Mode, "MODE #Fins -s" do |msg|
    msg.channel= "#Fins"
    msg.negative_flags!
    msg.chan_secret!
  end

  it_generates IRCParser::Messages::Mode, "MODE #42 +k oulu" do |msg|
    msg.channel= "#42"
    msg.key= "oulu"
    msg.positive_flags!
    msg.chan_password!
  end

  it_generates IRCParser::Messages::Mode, "MODE #eu-opers +l 10" do |msg|
    msg.channel= "#eu-opers"
    msg.limit= "10"
    msg.positive_flags!
    msg.chan_users_limit!
  end

  it_generates IRCParser::Messages::Mode, "MODE &oulu +b" do |msg|
    msg.channel= "&oulu"
    msg.positive_flags!
    msg.chan_ban_mask!
  end

  it_generates IRCParser::Messages::Mode, "MODE &oulu +b *!*@*" do |msg|
    msg.channel= "&oulu"
    msg.limit= "*!*@*"
    msg.positive_flags!
    msg.chan_ban_mask!
  end

  it_generates IRCParser::Messages::Mode, "MODE &oulu +b *!*@*.edu" do |msg|
    msg.channel= "&oulu"
    msg.limit= "*!*@*.edu"
    msg.positive_flags!
    msg.chan_ban_mask!
  end
end
