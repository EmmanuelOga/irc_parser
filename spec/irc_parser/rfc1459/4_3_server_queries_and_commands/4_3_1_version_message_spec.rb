require 'spec_helper'

describe IRCParser, "parsing version msg" do

  # ; msg from Wiz to check the version of a server matching "*.se"
  it_parses ":Wiz VERSION *.se" do |msg|
    msg.prefix.should == "Wiz"
    msg.server.should == "*.se"
  end

  # ; check the version of server "tolsun.oulu.fi".
  it_parses "VERSION tolsun.oulu.fi" do |msg|
    msg.prefix.should be_nil
    msg.server.should == "tolsun.oulu.fi"
  end

  #------------------------------------------------------------------------------

  # ; msg from Wiz to check the version of a server matching "*.se"
  it_generates IRCParser::Messages::Version, ":Wiz VERSION *.se" do |msg|
    msg.prefix= "Wiz"
    msg.server= "*.se"
  end

  # ; check the version of server "tolsun.oulu.fi".
  it_generates  IRCParser::Messages::Version, "VERSION tolsun.oulu.fi" do |msg|
    msg.server= "tolsun.oulu.fi"
  end

end
