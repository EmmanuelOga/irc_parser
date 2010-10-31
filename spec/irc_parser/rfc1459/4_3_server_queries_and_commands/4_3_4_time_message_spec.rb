require 'spec_helper'

describe IRCParser, "parsing time msg" do

  it_parses "TIME" do |msg|
  end

  # ; check the time on the server "tolson.oulu.fi"
  it_parses "TIME tolsun.oulu.fi" do |msg|
    msg.for_server.should == "tolsun.oulu.fi"
  end

  # ; user angel checking the time on a server matching "*.au"
  it_parses ":Angel TIME *.au" do |msg|
    msg.prefix.should == "Angel"
    msg.for_server.should == "*.au"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Time, "TIME" do |msg|
  end

  # ; check the time on the server "tolson.oulu.fi"
  it_generates IRCParser::Messages::Time, "TIME tolsun.oulu.fi" do |msg|
    msg.for_server= "tolsun.oulu.fi"
  end

  # ; user angel checking the time on a server matching "*.au"
  it_generates IRCParser::Messages::Time, ":Angel TIME *.au" do |msg|
    msg.prefix= "Angel"
    msg.for_server= "*.au"
  end
end
