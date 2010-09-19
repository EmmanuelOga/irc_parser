require 'spec_helper'

describe IRCParser, "parsing ison message" do
  # Parameters: <nickname>{<space><nickname>}

  # ; Sample ISON request for 7 nicks.
  it_parses "ISON phone trillian WiZ jarlek Avalon Angel Monstah" do |message|
    message.parameters.should == %w|phone trillian WiZ jarlek Avalon Angel Monstah|
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::IsOn, "ISON phone trillian WiZ jarlek Avalon Angel Monstah" do |message|
    message.nicks = %w|phone trillian WiZ jarlek Avalon Angel|
    message.nicks << "Monstah"
  end
end
