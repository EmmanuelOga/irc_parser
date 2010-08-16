require 'spec_helper'

describe IRCParser, "parsing server message" do

  it_parses "SERVER test.oulu.fi 1 :[tolsun.oulu.fi] Experimental server" do |message|
    message.server.should == "test.oulu.fi"
    message.hopcount.should == 1
    message.info.should == "[tolsun.oulu.fi] Experimental server"
  end

  it_parses ":tolsun.oulu.fi SERVER csd.bu.edu 5 :BU Central Server" do |message|
    message.prefix.should == "tolsun.oulu.fi"
    message.server.should == "csd.bu.edu"
    message.hopcount.should == 5
    message.info.should == "BU Central Server"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Server, "SERVER test.oulu.fi 1 :[tolsun.oulu.fi] Experimental server" do |message|
    message.server= "test.oulu.fi"
    message.hopcount= 1
    message.info= "[tolsun.oulu.fi] Experimental server"
  end

  it_generates IRCParser::Messages::Server, ":tolsun.oulu.fi SERVER csd.bu.edu 5 :BU Central Server" do |message|
    message.prefix= "tolsun.oulu.fi"
    message.server= "csd.bu.edu"
    message.hopcount= 5
    message.info= "BU Central Server"
  end

end
