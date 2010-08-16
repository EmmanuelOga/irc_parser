require 'spec_helper'

describe IRCParser, "parsing nick message" do

  it_parses "NICK Wiz" do |message| # Introducing new nick "Wiz".
    message.nick.should == "Wiz"
    message.hopcount.should be_nil
  end

  it_parses "NICK Wiz 10" do |message| # nick "Wiz" with hopcount.
    message.nick.should == "Wiz"
    message.hopcount.should == "10"
  end

  it_parses ":WiZ NICK Kilroy" do |message| # WiZ changed his nickname to Kilroy.
    message.nick.should == "Kilroy"
    message.prefix.should == "WiZ"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Nick, "NICK Wiz" do |message| # Introducing new nick "Wiz".
    message.nick = "Wiz"
  end

  it_generates IRCParser::Messages::Nick, "NICK Wiz 10" do |message| # nick "Wiz" with hopcount.
    message.nick = "Wiz"
    message.hopcount = "10"
  end

  it_generates IRCParser::Messages::Nick, ":WiZ NICK Kilroy" do |message| # WiZ changed his nickname to Kilroy.
    message.nick = "Kilroy"
    message.prefix = "WiZ"
  end
end
