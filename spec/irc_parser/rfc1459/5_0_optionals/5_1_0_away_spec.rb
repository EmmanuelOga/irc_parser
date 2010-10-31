require 'spec_helper'

describe IRCParser, "parsing away" do
  # Parameters: [msg]

  # ; set away msg to "Gone to lunch. Back in 5".
  it_parses "AWAY :Gone to lunch.  Back in 5" do |msg|
    msg.away_message.should == "Gone to lunch.  Back in 5"
  end

  # ; unmark WiZ as being away.
  it_parses ":WiZ AWAY" do |msg|
    msg.prefix.should == "WiZ"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Away, "AWAY :Gone to lunch.  Back in 5" do |msg|
    msg.away_message= "Gone to lunch.  Back in 5"
  end

  it_generates IRCParser::Messages::Away, ":WiZ AWAY" do |msg|
    msg.prefix= "WiZ"
  end
end
