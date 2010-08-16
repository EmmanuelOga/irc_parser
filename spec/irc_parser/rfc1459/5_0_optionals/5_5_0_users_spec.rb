require 'spec_helper'

describe IRCParser, "parsing users" do
  # Parameters: [<server>]

  # ; request a list of users logged in on server eff.org
  it_parses "USERS eff.org" do |message|
    message.of_server.should == "eff.org"
  end

  # ; request from John for a list of users logged in on server tolsun.oulu.fi
  it_parses ":John USERS tolsun.oulu.fi" do |message|
    message.from.should == "John"
    message.of_server.should == "tolsun.oulu.fi"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Users, "USERS eff.org" do |message|
    message.of_server= "eff.org"
  end

  it_generates IRCParser::Messages::Users, ":John USERS tolsun.oulu.fi" do |message|
    message.from= "John"
    message.of_server= "tolsun.oulu.fi"
  end
end
