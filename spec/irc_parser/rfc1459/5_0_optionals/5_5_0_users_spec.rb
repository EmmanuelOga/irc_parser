require 'spec_helper'

describe IRCParser, "parsing users" do
  # Parameters: [<server>]

  # ; request a list of users logged in on server eff.org
  it_parses "USERS eff.org" do |msg|
    msg.target.should == "eff.org"
  end

  # ; request from John for a list of users logged in on server tolsun.oulu.fi
  it_parses ":John USERS tolsun.oulu.fi" do |msg|
    msg.prefix.should == "John"
    msg.target.should == "tolsun.oulu.fi"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Users, "USERS eff.org" do |msg|
    msg.target= "eff.org"
  end

  it_generates IRCParser::Messages::Users, ":John USERS tolsun.oulu.fi" do |msg|
    msg.prefix= "John"
    msg.target= "tolsun.oulu.fi"
  end
end
