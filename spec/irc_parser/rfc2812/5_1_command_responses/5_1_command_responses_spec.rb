require 'spec_helper'

describe IRCParser, "command responses" do

  it_parses "001 emmanuel :Welcome to the Internet Relay Network nick!user@host.com" do |msg|
    msg.nick.should == "emmanuel"
    msg.postfix.should == "Welcome to the Internet Relay Network nick!user@host.com"
  end

  it_parses "002 emmanuel :Your host is server.name running version 1.2.0"  do |msg|
    msg.nick.should == "emmanuel"
    msg.postfix.should == "Your host is server.name running version 1.2.0"
  end

  it_parses "003 emmanuel :This server was created 10/10/2010 15:28:10" do |msg|
    msg.nick.should == "emmanuel"
    msg.postfix.should == "This server was created 10/10/2010 15:28:10"
  end

  it_parses "004 emmanuel server.name 1.2.3 AbC xYz"  do |msg|
    msg.nick.should == "emmanuel"
    msg.server_name.should == "server.name"
    msg.version.should == "1.2.3"
    msg.available_user_modes.should == "AbC"
    msg.available_channel_modes.should == "xYz"
  end

  it_parses "005 emmanuel :Try server server.name port 10000"  do |msg|
    msg.nick.should == "emmanuel"
    msg.postfix.should == "Try server server.name port 10000"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::RplWelcome, "001 emmanuel :Welcome to the Internet Relay Network nick!user@host.com" do |msg|
    msg.nick = "emmanuel"
    msg.format_postfix(:welcome => "Welcome to the Internet Relay Network", :user => "nick!user@host.com")
  end

  it_generates IRCParser::Messages::RplYourHost, "002 emmanuel :Your host is server.name running version 1.2.0"  do |msg|
    msg.nick = "emmanuel"
    msg.format_postfix :server_name => "server.name", :version => "1.2.0"
  end

  it_generates IRCParser::Messages::RplCreated, "003 emmanuel :This server was created 10/10/2010 15:28:10" do |msg|
    msg.nick = "emmanuel"
    msg.format_postfix :date => "10/10/2010 15:28:10"
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
    msg.format_postfix :server_name => "server.name", :port => "10000"
  end

end
