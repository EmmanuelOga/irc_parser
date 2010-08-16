require 'spec_helper'

describe IRCParser, "parsing away" do
  # Parameters: [message]

  # ; set away message to "Gone to lunch. Back in 5".
  it_parses "AWAY :Gone to lunch.  Back in 5" do |message|
    message.away_message.should == "Gone to lunch.  Back in 5"
  end

  # ; unmark WiZ as being away.
  it_parses ":WiZ AWAY" do |message|
    message.prefix.should == "WiZ"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Away, "AWAY :Gone to lunch.  Back in 5" do |message|
    message.away_message= "Gone to lunch.  Back in 5"
  end

  it_generates IRCParser::Messages::Away, ":WiZ AWAY" do |message|
    message.prefix= "WiZ"
  end
end
