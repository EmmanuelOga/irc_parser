require 'spec_helper'

describe IRCParser, "parsing kick command" do

  # ; Kick Matthew from &Melbourne
  it_parses "KICK &Melbourne Matthew" do |msg|
    msg.channels.should == ["&Melbourne"]
    msg.users.should == ["Matthew"]
    msg.kick_message.should be_nil
  end

  # ; Kick Matthew and Jason from &Melbourne and #other
  it_parses "KICK &Melbourne,#other Matthew,Jason" do |msg|
    msg.channels.should == ["&Melbourne", "#other"]
    msg.users.should == ["Matthew", "Jason"]
    msg.kick_message.should be_nil
  end

  # ; Kick John from #Finnish using "Speaking English" as the reason (comment).
  it_parses "KICK #Finnish John :Speaking English" do |msg|
    msg.channels.should == ["#Finnish"]
    msg.users.should == ["John"]
    msg.kick_message.should == "Speaking English"
  end

  # ; KICK msg from WiZ to remove John from channel #Finnish
  it_parses ":WiZ KICK #Finnish John" do |msg|
    msg.prefix.should == "WiZ"
    msg.channels.should == ["#Finnish"]
    msg.users.should == ["John"]
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Kick, "KICK &Melbourne Matthew" do |msg|
    msg.channels= ["&Melbourne"]
    msg.users= ["Matthew"]
  end

  it_generates IRCParser::Messages::Kick, "KICK &Melbourne,#other Matthew,Jason" do |msg|
    msg.channels= ["&Melbourne", "#other"]
    msg.users= ["Matthew", "Jason"]
  end

  it_generates IRCParser::Messages::Kick, "KICK #Finnish John :Speaking English" do |msg|
    msg.channels = "#Finnish"
    msg.users = "John"
    msg.kick_message = "Speaking English"
  end

  it_generates IRCParser::Messages::Kick, ":WiZ KICK #Finnish John" do |msg|
    msg.prefix= "WiZ"
    msg.channels= ["#Finnish"]
    msg.users= ["John"]
  end
end
