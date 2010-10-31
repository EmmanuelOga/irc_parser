require 'spec_helper'

describe IRCParser, "parsing server msg" do

  it_parses "SERVER test.oulu.fi 1 :[tolsun.oulu.fi] Experimental server" do |msg|
    msg.server.should == "test.oulu.fi"
    msg.hopcount.should == 1
    msg.info.should == "[tolsun.oulu.fi] Experimental server"
  end

  it_parses ":tolsun.oulu.fi SERVER csd.bu.edu 5 :BU Central Server" do |msg|
    msg.prefix.should == "tolsun.oulu.fi"
    msg.server.should == "csd.bu.edu"
    msg.hopcount.should == 5
    msg.info.should == "BU Central Server"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Server, "SERVER test.oulu.fi 1 :[tolsun.oulu.fi] Experimental server" do |msg|
    msg.server= "test.oulu.fi"
    msg.hopcount= 1
    msg.info= "[tolsun.oulu.fi] Experimental server"
  end

  it_generates IRCParser::Messages::Server, ":tolsun.oulu.fi SERVER csd.bu.edu 5 :BU Central Server" do |msg|
    msg.prefix= "tolsun.oulu.fi"
    msg.server= "csd.bu.edu"
    msg.hopcount= 5
    msg.info= "BU Central Server"
  end

end
