require 'spec_helper'

describe IRCParser, "parsing whowas" do
  # Parameters: <nickname> [<count> [<server>]]

  # ; return all information in the nick history about nick "WiZ";
  it_parses "WHOWAS Wiz" do |msg|
    msg.nick.should == "Wiz"
  end

  # ; return at most, the 9 most recent entries in the nick history for "Mermaid";
  it_parses "WHOWAS Mermaid 9" do |msg|
    msg.nick.should == "Mermaid"
    msg.count.should == 9
  end

  # ; return the most recent history for "Trillian" from the first server found to match "*.edu".
  it_parses "WHOWAS Trillian 1 *.edu" do |msg|
    msg.nick.should == "Trillian"
    msg.count.should == 1
    msg.server.should == "*.edu"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::WhoWas, "WHOWAS Wiz" do |msg|
    msg.nick= "Wiz"
  end

  it_generates IRCParser::Messages::WhoWas, "WHOWAS Mermaid 9" do |msg|
    msg.nick= "Mermaid"
    msg.count= 9
  end

  it_generates IRCParser::Messages::WhoWas, "WHOWAS Trillian 1 *.edu" do |msg|
    msg.nick= "Trillian"
    msg.count= 1
    msg.server= "*.edu"
  end
end
