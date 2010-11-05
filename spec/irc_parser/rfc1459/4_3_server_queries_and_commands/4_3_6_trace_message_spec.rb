require 'spec_helper'

describe IRCParser, "parsing trace msg" do

  # ; TRACE to a target matching *.oulu.fi
  it_parses "TRACE *.oulu.fi" do |msg|
    msg.target.should == "*.oulu.fi"
  end

  # ; TRACE issued by WiZ to nick AngelDust
  it_parses ":WiZ TRACE AngelDust" do |msg|
    msg.prefix.should == "WiZ"
    msg.target.should == "AngelDust"
  end

  #------------------------------------------------------------------------------

  # ; TRACE to a target matching *.oulu.fi
  it_generates IRCParser::Messages::Trace, "TRACE *.oulu.fi" do |msg|
    msg.target= "*.oulu.fi"
  end

  # ; TRACE issued by WiZ to nick AngelDust
  it_generates IRCParser::Messages::Trace, ":WiZ TRACE AngelDust" do |msg|
    msg.prefix= "WiZ"
    msg.target= "AngelDust"
  end
end
