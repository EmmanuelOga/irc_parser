require 'spec_helper'

describe IRCParser, "parsing userhost message" do
  # Parameters: <nickname>{<space><nickname>}

  # ; USERHOST request for information on nicks "Wiz", "Michael", "Marty" and "p"
  it_parses "USERHOST Wiz Michael Marty p" do |message|
    message.nicks.should == %w|Wiz Michael Marty p|
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Userhost, "USERHOST Wiz Michael Marty p" do |message|
    message.nicks= %w|Wiz Michael Marty p|
  end
end
