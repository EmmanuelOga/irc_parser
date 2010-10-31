require 'spec_helper'

describe IRCParser, "parsing server quit msg" do

  it_parses "SQUIT tolsun.oulu.fi :Bad Link ?" do |msg|
    msg.server.should == "tolsun.oulu.fi"
    msg.reason.should == "Bad Link ?"
  end

  it_parses ":Trillian SQUIT cm22.eng.umd.edu :Server out of control" do |msg|
    msg.server.should == "cm22.eng.umd.edu"
    msg.reason.should == "Server out of control"
    msg.from.should == "Trillian"
    msg.server.should == "cm22.eng.umd.edu"
    msg.reason.should == "Server out of control"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::SQuit, "SQUIT tolsun.oulu.fi :Bad Link ?" do |msg|
    msg.server= "tolsun.oulu.fi"
    msg.reason= "Bad Link ?"
  end

  it_generates IRCParser::Messages::SQuit, ":Trillian SQUIT cm22.eng.umd.edu :Server out of control" do |msg|
    msg.server= "cm22.eng.umd.edu"
    msg.reason= "Server out of control"
    msg.from= "Trillian"
    msg.server= "cm22.eng.umd.edu"
    msg.reason= "Server out of control"
  end
end
