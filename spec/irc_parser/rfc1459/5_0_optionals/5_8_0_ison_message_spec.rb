require 'spec_helper'

describe IRCParser, "parsing ison msg" do
  # Parameters: <nickname>{<space><nickname>}

  # ; Sample ISON request for 7 nicks.
  it_parses "ISON phone trillian WiZ jarlek Avalon Angel Monstah" do |msg|
    msg.parameters.should == %w|phone trillian WiZ jarlek Avalon Angel Monstah|
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::IsOn, "ISON phone trillian WiZ jarlek Avalon Angel Monstah" do |msg|
    msg.nicks = %w|phone trillian WiZ jarlek Avalon Angel|
    msg.nicks << "Monstah"
  end
end
