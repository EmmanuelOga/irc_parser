require 'spec_helper'

describe IRCParser, "parsing userhost msg" do
  # Parameters: <nickname>{<space><nickname>}

  # ; USERHOST request for information on nicks "Wiz", "Michael", "Marty" and "p"
  it_parses "USERHOST Wiz Michael Marty p" do |msg|
    msg.nicks.should == %w|Wiz Michael Marty p|
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::UserHost, "USERHOST Wiz Michael Marty p" do |msg|
    msg.nicks= %w|Wiz Michael Marty p|
  end
end
