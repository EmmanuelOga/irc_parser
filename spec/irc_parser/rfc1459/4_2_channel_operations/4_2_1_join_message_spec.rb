require 'spec_helper'

describe IRCParser, "parsing join msg" do

  it_parses "JOIN #foobar" do |msg|
    msg.channels.should == ["#foobar"]
    msg.keys.should == []
  end

  it_parses "JOIN &foo fubar" do |msg|
    msg.channels.should == ["&foo"]
    msg.keys.should == ["fubar"]
  end

  it_parses "JOIN #foo,&bar fubar" do |msg|
    msg.channels.should == ["#foo", "&bar"]
    msg.keys.should == ["fubar"]
  end

  it_parses "JOIN #foo,#bar fubar,foobar" do |msg|
    msg.channels.should == ["#foo", "#bar"]
    msg.keys.should == ["fubar", "foobar"]
  end

  it_parses "JOIN #foo,#bar" do |msg|
    msg.channels.should == ["#foo", "#bar"]
    msg.keys.should == []
  end

  it_parses ":WiZ JOIN #Twilight_zone" do |msg|
    msg.channels.should == ["#Twilight_zone"]
    msg.keys.should == []
    msg.prefix.should == "WiZ"
  end

  #-------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Join, "JOIN #foobar" do |msg|
    msg.channels= ["#foobar"]
  end

  it_generates IRCParser::Messages::Join, "JOIN &foo fubar" do |msg|
    msg.channels= ["&foo"]
    msg.keys= ["fubar"]
  end

  it_generates IRCParser::Messages::Join, "JOIN #foo,&bar fubar" do |msg|
    msg.channels= ["#foo", "&bar"]
    msg.keys= ["fubar"]
  end

  it_generates IRCParser::Messages::Join, "JOIN #foo,#bar fubar,foobar" do |msg|
    msg.channels= ["#foo", "#bar"]
    msg.keys= ["fubar", "foobar"]
  end

  it_generates IRCParser::Messages::Join, "JOIN #foo,#bar" do |msg|
    msg.channels= ["#foo", "#bar"]
  end

  it_generates IRCParser::Messages::Join, ":WiZ JOIN #Twilight_zone" do |msg|
    msg.channels= ["#Twilight_zone"]
    msg.prefix= "WiZ"
  end
end
