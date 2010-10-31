require 'spec_helper'

describe IRCParser, "parsing user modes" do

  it_parses "MODE WiZ -w" do |msg| # ; turns reception of WALLOPS messages off for WiZ.
    msg.nick.should == "WiZ"

    msg.flags.should == "-w"
    msg.should be_user_flags_include_wallops_receptor
    msg.should_not be_user_wallops_receptor
  end

  it_parses ":Angel MODE Angel +i" do |msg| # ; Message from Angel to make themselves invisible.
    msg.nick.should == "Angel"
    msg.prefix.should == "Angel"

    msg.flags.should == "+i"
    msg.should be_user_flags_include_invisible
    msg.should be_user_invisible
  end

  # ; WiZ 'deopping' (removing operator status).  The plain reverse of this command
  # ("MODE WiZ +o") must not be allowed from users since would bypass the OPER command.
  it_parses "MODE WiZ -o" do |msg|
    msg.nick.should == "WiZ"

    msg.flags.should == "-o"
    msg.should be_user_flags_include_operator
    msg.should_not be_user_operator
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Mode, "MODE WiZ -w" do |msg| # ; turns reception of WALLOPS messages off for WiZ.
    msg.nick= "WiZ"
    msg.negative_flags!
    msg.user_wallops_receptor!
  end

  it_generates IRCParser::Messages::Mode, ":Angel MODE Angel +i" do |msg| # ; Message from Angel to make themselves invisible.
    msg.prefix = "Angel"
    msg.nick= "Angel"

    msg.positive_flags!
    msg.user_invisible!
  end

  it_generates IRCParser::Messages::Mode, "MODE WiZ -o" do |msg|
    msg.nick= "WiZ"

    msg.negative_flags!
    msg.user_operator!
  end

end
