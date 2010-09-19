require 'spec_helper'

describe IRCParser, "parsing whowas" do
  # Parameters: <nickname> [<count> [<server>]]

  # ; return all information in the nick history about nick "WiZ";
  it_parses "WHOWAS Wiz" do |message|
    message.nick.should == "Wiz"
  end

  # ; return at most, the 9 most recent entries in the nick history for "Mermaid";
  it_parses "WHOWAS Mermaid 9" do |message|
    message.nick.should == "Mermaid"
    message.count.should == 9
  end

  # ; return the most recent history for "Trillian" from the first server found to match "*.edu".
  it_parses "WHOWAS Trillian 1 *.edu" do |message|
    message.nick.should == "Trillian"
    message.count.should == 1
    message.server.should == "*.edu"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::WhoWas, "WHOWAS Wiz" do |message|
    message.nick= "Wiz"
  end

  it_generates IRCParser::Messages::WhoWas, "WHOWAS Mermaid 9" do |message|
    message.nick= "Mermaid"
    message.count= 9
  end

  it_generates IRCParser::Messages::WhoWas, "WHOWAS Trillian 1 *.edu" do |message|
    message.nick= "Trillian"
    message.count= 1
    message.server= "*.edu"
  end
end
