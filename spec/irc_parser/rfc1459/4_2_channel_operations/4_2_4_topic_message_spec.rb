require 'spec_helper'

describe IRCParser, "parsing topic message" do

  it_parses ":Wiz TOPIC #test :New topic" do |message| # ;User Wiz setting the topic.
    message.channel.should == "#test"
    message.topic.should == "New topic"
  end

  it_parses "TOPIC #test :another topic" do |message| # ;set the topic on #test to "anothe topic".
    message.channel.should == "#test"
    message.topic.should == "another topic"
  end

  it_parses "TOPIC #test" do |message| # ; check the topic for #test.
    message.channel.should == "#test"
    message.topic.should be_nil
  end

  it_parses "TOPIC #test" do |message|
    message.should_not be_topic_given
  end

  it_parses "TOPIC #test :Hola Manola" do |message|
    message.should be_topic_given
  end

  it_parses "TOPIC #test :" do |message|
    message.should be_topic_given
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Topic, ":Wiz TOPIC #test :New topic" do |message| # ;User Wiz setting the topic.
    message.prefix= "Wiz"
    message.channel= "#test"
    message.topic= "New topic"
  end

  it_generates IRCParser::Messages::Topic, "TOPIC #test :another topic" do |message| # ;set the topic on #test to "anothe topic".
    message.channel= "#test"
    message.topic= "another topic"
  end

  it_generates IRCParser::Messages::Topic, "TOPIC #test" do |message| # ; check the topic for #test.
    message.channel= "#test"
  end
end
