require 'spec_helper'

describe IRCParser, "parsing nick msg" do

  it_parses "NICK Wiz" do |msg| # Introducing new nick "Wiz".
    msg.nick.should == "Wiz"
    msg.hopcount.should be_nil
  end

  it_parses "NICK Wiz 10" do |msg| # nick "Wiz" with hopcount.
    msg.nick.should == "Wiz"
    msg.hopcount.should == "10"
  end

  it_parses ":WiZ NICK Kilroy" do |msg| # WiZ changed his nickname to Kilroy.
    msg.nick.should == "Kilroy"
    msg.prefix.should == "WiZ"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Nick, "NICK Wiz" do |msg| # Introducing new nick "Wiz".
    msg.nick = "Wiz"
  end

  it_generates IRCParser::Messages::Nick, "NICK Wiz 10" do |msg| # nick "Wiz" with hopcount.
    msg.nick = "Wiz"
    msg.hopcount = "10"
  end

  it_generates IRCParser::Messages::Nick, ":WiZ NICK Kilroy" do |msg| # WiZ changed his nickname to Kilroy.
    msg.nick = "Kilroy"
    msg.prefix = "WiZ"
  end
end
