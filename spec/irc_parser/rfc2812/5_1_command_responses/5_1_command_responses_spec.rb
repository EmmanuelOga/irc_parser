require 'spec_helper'

describe IRCParser, "command responses" do

  it_parses "001 emmanuel :Welcome to the Internet Relay Network nick!user@host.com" do |msg|
    msg.welcome.should == "Welcome to the Internet Relay Network"
    msg.user.should == "nick!user@host.com"
  end

  it_parses "002 emmanuel :Your host is server.name running version 1.2.0"  do |msg|
    msg.server_name.should == "server.name"
    msg.version.should == "1.2.0"
  end

  it_parses "003 emmanuel :This server was created 10/10/2010 15:28:10" do |msg|
    msg.date.should == "10/10/2010 15:28:10"
  end

  it_parses "004 emmanuel server.name 1.2.3 AbC xYz"  do |msg|
    msg.server_name.should == "server.name"
    msg.version.should == "1.2.3"
    msg.available_user_modes.should == "AbC"
    msg.available_channel_modes.should == "xYz"
  end

  it_parses "005 emmanuel :Try server server.name port 10000"  do |msg|
    msg.server_name.should == "server.name"
    msg.port.should == "10000"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::RplWelcome, "001 emmanuel :Welcome to the Internet Relay Network nick!user@host.com" do |msg|
    msg.nick = "emmanuel"
    msg.welcome= "Welcome to the Internet Relay Network"
    msg.user= "nick!user@host.com"
  end

  it_generates IRCParser::Messages::RplYourHost, "002 emmanuel :Your host is server.name running version 1.2.0"  do |msg|
    msg.nick = "emmanuel"
    msg.server_name= "server.name"
    msg.version= "1.2.0"
  end

  it_generates IRCParser::Messages::RplCreated, "003 emmanuel :This server was created 10/10/2010 15:28:10" do |msg|
    msg.nick = "emmanuel"
    msg.date= "10/10/2010 15:28:10"
  end

  it_generates IRCParser::Messages::RplMyInfo, "004 emmanuel server.name 1.2.3 AbC xYz"  do |msg|
    msg.nick = "emmanuel"
    msg.server_name= "server.name"
    msg.version= "1.2.3"
    msg.available_user_modes= "AbC"
    msg.available_channel_modes= "xYz"
  end

  it_generates IRCParser::Messages::RplBounce, "005 emmanuel :Try server server.name port 10000"  do |msg|
    msg.nick = "emmanuel"
    msg.server_name= "server.name"
    msg.port= "10000"
  end

end
