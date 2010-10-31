require 'spec_helper'

describe IRCParser, "parsing topic msg" do

  it_parses ":Wiz TOPIC #test :New topic" do |msg| # ;User Wiz setting the topic.
    msg.channel.should == "#test"
    msg.topic.should == "New topic"
  end

  it_parses "TOPIC #test :another topic" do |msg| # ;set the topic on #test to "anothe topic".
    msg.channel.should == "#test"
    msg.topic.should == "another topic"
  end

  it_parses "TOPIC #test" do |msg| # ; check the topic for #test.
    msg.channel.should == "#test"
    msg.topic.should be_nil
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Topic, ":Wiz TOPIC #test :New topic" do |msg| # ;User Wiz setting the topic.
    msg.prefix= "Wiz"
    msg.channel= "#test"
    msg.topic= "New topic"
  end

  it_generates IRCParser::Messages::Topic, "TOPIC #test :another topic" do |msg| # ;set the topic on #test to "anothe topic".
    msg.channel= "#test"
    msg.topic= "another topic"
  end

  it_generates IRCParser::Messages::Topic, "TOPIC #test" do |msg| # ; check the topic for #test.
    msg.channel= "#test"
  end
end
