require 'spec_helper'

describe IRCParser, "parsing join message" do

  it_parses "JOIN #foobar" do |message|
    message.channels.should == ["#foobar"]
    message.keys.should == []
  end

  it_parses "JOIN &foo fubar" do |message|
    message.channels.should == ["&foo"]
    message.keys.should == ["fubar"]
  end

  it_parses "JOIN #foo,&bar fubar" do |message|
    message.channels.should == ["#foo", "&bar"]
    message.keys.should == ["fubar"]
  end

  it_parses "JOIN #foo,#bar fubar,foobar" do |message|
    message.channels.should == ["#foo", "#bar"]
    message.keys.should == ["fubar", "foobar"]
  end

  it_parses "JOIN #foo,#bar" do |message|
    message.channels.should == ["#foo", "#bar"]
    message.keys.should == []
  end

  it_parses ":WiZ JOIN #Twilight_zone" do |message|
    message.channels.should == ["#Twilight_zone"]
    message.keys.should == []
    message.from.should == "WiZ"
  end

  #-------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Join, "JOIN #foobar" do |message|
    message.channels= ["#foobar"]
  end

  it_generates IRCParser::Messages::Join, "JOIN &foo fubar" do |message|
    message.channels= ["&foo"]
    message.keys= ["fubar"]
  end

  it_generates IRCParser::Messages::Join, "JOIN #foo,&bar fubar" do |message|
    message.channels= ["#foo", "&bar"]
    message.keys= ["fubar"]
  end

  it_generates IRCParser::Messages::Join, "JOIN #foo,#bar fubar,foobar" do |message|
    message.channels= ["#foo", "#bar"]
    message.keys= ["fubar", "foobar"]
  end

  it_generates IRCParser::Messages::Join, "JOIN #foo,#bar" do |message|
    message.channels= ["#foo", "#bar"]
  end

  it_generates IRCParser::Messages::Join, ":WiZ JOIN #Twilight_zone" do |message|
    message.channels= ["#Twilight_zone"]
    message.from= "WiZ"
  end
end
