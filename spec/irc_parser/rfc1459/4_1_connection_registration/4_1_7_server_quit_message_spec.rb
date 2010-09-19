require 'spec_helper'

describe IRCParser, "parsing server quit message" do

  it_parses "SQUIT tolsun.oulu.fi :Bad Link ?" do |message|
    message.server.should == "tolsun.oulu.fi"
    message.reason.should == "Bad Link ?"
  end

  it_parses ":Trillian SQUIT cm22.eng.umd.edu :Server out of control" do |message|
    message.server.should == "cm22.eng.umd.edu"
    message.reason.should == "Server out of control"
    message.from.should == "Trillian"
    message.server.should == "cm22.eng.umd.edu"
    message.reason.should == "Server out of control"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::SQuit, "SQUIT tolsun.oulu.fi :Bad Link ?" do |message|
    message.server= "tolsun.oulu.fi"
    message.reason= "Bad Link ?"
  end

  it_generates IRCParser::Messages::SQuit, ":Trillian SQUIT cm22.eng.umd.edu :Server out of control" do |message|
    message.server= "cm22.eng.umd.edu"
    message.reason= "Server out of control"
    message.from= "Trillian"
    message.server= "cm22.eng.umd.edu"
    message.reason= "Server out of control"
  end
end
