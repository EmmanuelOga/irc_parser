require 'spec_helper'

describe IRCParser, "parsing version message" do

  # ; message from Wiz to check the version of a server matching "*.se"
  it_parses ":Wiz VERSION *.se" do |message|
    message.prefix.should == "Wiz"
    message.server.should == "*.se"
  end

  # ; check the version of server "tolsun.oulu.fi".
  it_parses "VERSION tolsun.oulu.fi" do |message|
    message.prefix.should be_nil
    message.server.should == "tolsun.oulu.fi"
  end

  #------------------------------------------------------------------------------

  # ; message from Wiz to check the version of a server matching "*.se"
  it_generates IRCParser::Messages::Version, ":Wiz VERSION *.se" do |message|
    message.prefix= "Wiz"
    message.server= "*.se"
  end

  # ; check the version of server "tolsun.oulu.fi".
  it_generates  IRCParser::Messages::Version, "VERSION tolsun.oulu.fi" do |message|
    message.server= "tolsun.oulu.fi"
  end

end
