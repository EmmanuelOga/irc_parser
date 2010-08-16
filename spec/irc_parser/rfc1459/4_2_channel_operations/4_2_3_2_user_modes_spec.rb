require 'spec_helper'

describe IRCParser, "parsing user modes" do

  it_parses "MODE WiZ -w" do |message| # ; turns reception of WALLOPS messages off for WiZ.
    message.nick.should == "WiZ"

    message.flags.should == "-w"
    message.should be_user_flags_include_wallops_receptor
    message.should_not be_user_wallops_receptor
  end

  it_parses ":Angel MODE Angel +i" do |message| # ; Message from Angel to make themselves invisible.
    message.nick.should == "Angel"
    message.prefix.should == "Angel"

    message.flags.should == "+i"
    message.should be_user_flags_include_invisible
    message.should be_user_invisible
  end

  # ; WiZ 'deopping' (removing operator status).  The plain reverse of this command
  # ("MODE WiZ +o") must not be allowed from users since would bypass the OPER command.
  it_parses "MODE WiZ -o" do |message|
    message.nick.should == "WiZ"

    message.flags.should == "-o"
    message.should be_user_flags_include_operator
    message.should_not be_user_operator
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Mode, "MODE WiZ -w" do |message| # ; turns reception of WALLOPS messages off for WiZ.
    message.nick= "WiZ"
    message.negative_flags!
    message.user_wallops_receptor!
  end

  it_generates IRCParser::Messages::Mode, ":Angel MODE Angel +i" do |message| # ; Message from Angel to make themselves invisible.
    message.prefix = "Angel"
    message.nick= "Angel"

    message.positive_flags!
    message.user_invisible!
  end

  it_generates IRCParser::Messages::Mode, "MODE WiZ -o" do |message|
    message.nick= "WiZ"

    message.negative_flags!
    message.user_operator!
  end

end
