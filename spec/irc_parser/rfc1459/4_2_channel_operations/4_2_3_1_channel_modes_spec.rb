require 'spec_helper'

describe IRCParser, "parsing channel modes" do

  # ; Makes #Finnish channel moderated and 'invite-only'.
  it_parses "MODE #Finnish +im" do |message|
    message.channel.should == "#Finnish"
    message.user.should be_nil

    message.flags.should == "+im"
    message.should be_chan_flags_include_invite_only
    message.should be_chan_invite_only
    message.should be_chan_flags_include_moderated
    message.should be_chan_moderated
  end

  # ; Gives 'chanop' privileges to Kilroy on channel #Finnish.
  it_parses "MODE #Finnish +o Kilroy" do |message|
    message.channel.should == "#Finnish"
    message.user.should == "Kilroy"

    message.flags.should == "+o"
    message.should be_chan_flags_include_operator
    message.should be_chan_operator
  end

  # ; Allow WiZ to speak on #Finnish.
  it_parses "MODE #Finnish +v Wiz" do |message|
    message.channel.should == "#Finnish"
    message.user.should == "Wiz"

    message.flags.should == "+v"
    message.should be_chan_flags_include_speaker
    message.should be_chan_speaker
  end

  # ; Removes 'secret' flag from channel #Fins.
  it_parses "MODE #Fins -s" do |message|
    message.channel.should == "#Fins"
    message.user.should be_nil

    message.flags.should == "-s"
    message.should be_chan_flags_include_secret
    message.should_not be_chan_secret
  end

  # ; Set the channel key to "oulu".
  it_parses "MODE #42 +k oulu" do |message|
    message.channel.should == "#42"
    message.key.should == "oulu"

    message.flags.should == "+k"
    message.should be_chan_flags_include_password
    message.should be_chan_password
  end

  # ; Set the limit for the number of users on channel to 10.
  it_parses "MODE #eu-opers +l 10" do |message|
    message.channel.should == "#eu-opers"
    message.limit.should == "10"

    message.flags.should == "+l"
    message.should be_chan_flags_include_users_limit
    message.should be_chan_users_limit
  end

  # ; list ban masks set for channel.
  it_parses "MODE &oulu +b" do |message|
    message.channel.should == "&oulu"
    message.limit.should be_nil

    message.flags.should == "+b"
    message.should be_chan_flags_include_ban_mask
    message.should be_chan_ban_mask
  end

  # ; prevent all users from joining.
  it_parses "MODE &oulu +b *!*@*" do |message|
    message.channel.should == "&oulu"
    message.ban_mask.should == "*!*@*"

    message.flags.should == "+b"
    message.should be_chan_flags_include_ban_mask
    message.should be_chan_ban_mask
  end

  # ; prevent any user from a hostname matching *.edu from joining.
  it_parses "MODE &oulu +b *!*@*.edu" do |message|
    message.channel.should == "&oulu"
    message.ban_mask.should == "*!*@*.edu"

    message.flags.should == "+b"
    message.should be_chan_flags_include_ban_mask
    message.should be_chan_ban_mask
  end

  #-------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Mode, "MODE #Finnish +im" do |message|
    message.channel= "#Finnish"
    message.positive_flags!
    message.chan_invite_only!
    message.chan_moderated!
  end

  it_generates IRCParser::Messages::Mode, "MODE #Finnish +o Kilroy" do |message|
    message.channel= "#Finnish"
    message.user= "Kilroy"
    message.positive_flags!
    message.chan_operator!
  end

  it_generates IRCParser::Messages::Mode, "MODE #Finnish +v Wiz" do |message|
    message.channel= "#Finnish"
    message.user= "Wiz"
    message.positive_flags!
    message.chan_speaker!
  end

  it_generates IRCParser::Messages::Mode, "MODE #Fins -s" do |message|
    message.channel= "#Fins"
    message.negative_flags!
    message.chan_secret!
  end

  it_generates IRCParser::Messages::Mode, "MODE #42 +k oulu" do |message|
    message.channel= "#42"
    message.key= "oulu"
    message.positive_flags!
    message.chan_password!
  end

  it_generates IRCParser::Messages::Mode, "MODE #eu-opers +l 10" do |message|
    message.channel= "#eu-opers"
    message.limit= "10"
    message.positive_flags!
    message.chan_users_limit!
  end

  it_generates IRCParser::Messages::Mode, "MODE &oulu +b" do |message|
    message.channel= "&oulu"
    message.positive_flags!
    message.chan_ban_mask!
  end

  it_generates IRCParser::Messages::Mode, "MODE &oulu +b *!*@*" do |message|
    message.channel= "&oulu"
    message.limit= "*!*@*"
    message.positive_flags!
    message.chan_ban_mask!
  end

  it_generates IRCParser::Messages::Mode, "MODE &oulu +b *!*@*.edu" do |message|
    message.channel= "&oulu"
    message.limit= "*!*@*.edu"
    message.positive_flags!
    message.chan_ban_mask!
  end
end
