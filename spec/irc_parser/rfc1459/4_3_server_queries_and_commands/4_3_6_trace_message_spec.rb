require 'spec_helper'

describe IRCParser, "parsing trace message" do

  # ; TRACE to a server matching *.oulu.fi
  it_parses "TRACE *.oulu.fi" do |message|
    message.server.should == "*.oulu.fi"
  end

  # ; TRACE issued by WiZ to nick AngelDust
  it_parses ":WiZ TRACE AngelDust" do |message|
    message.prefix.should == "WiZ"
    message.to_nick.should == "AngelDust"
  end

  #------------------------------------------------------------------------------

  # ; TRACE to a server matching *.oulu.fi
  it_generates IRCParser::Messages::Trace, "TRACE *.oulu.fi" do |message|
    message.server= "*.oulu.fi"
  end

  # ; TRACE issued by WiZ to nick AngelDust
  it_generates IRCParser::Messages::Trace, ":WiZ TRACE AngelDust" do |message|
    message.prefix= "WiZ"
    message.to_nick= "AngelDust"
  end
end
