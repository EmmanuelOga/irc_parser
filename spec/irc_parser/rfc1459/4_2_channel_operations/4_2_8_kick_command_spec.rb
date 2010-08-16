require 'spec_helper'

describe IRCParser, "parsing kick command" do

  # ; Kick Matthew from &Melbourne
  it_parses "KICK &Melbourne Matthew" do |message|
    message.channels.should == ["&Melbourne"]
    message.users.should == ["Matthew"]
    message.kick_message.should be_nil
  end

  # ; Kick Matthew and Jason from &Melbourne and #other
  it_parses "KICK &Melbourne,#other Matthew,Jason" do |message|
    message.channels.should == ["&Melbourne", "#other"]
    message.users.should == ["Matthew", "Jason"]
    message.kick_message.should be_nil
  end

  # ; Kick John from #Finnish using "Speaking English" as the reason (comment).
  it_parses "KICK #Finnish John :Speaking English" do |message|
    message.channels.should == ["#Finnish"]
    message.users.should == ["John"]
    message.kick_message.should == "Speaking English"
  end

  # ; KICK message from WiZ to remove John from channel #Finnish
  it_parses ":WiZ KICK #Finnish John" do |message|
    message.prefix.should == "WiZ"
    message.channels.should == ["#Finnish"]
    message.users.should == ["John"]
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Kick, "KICK &Melbourne Matthew" do |message|
    message.channels= ["&Melbourne"]
    message.users= ["Matthew"]
  end

  it_generates IRCParser::Messages::Kick, "KICK &Melbourne,#other Matthew,Jason" do |message|
    message.channels= ["&Melbourne", "#other"]
    message.users= ["Matthew", "Jason"]
  end

  it_generates IRCParser::Messages::Kick, "KICK #Finnish John :Speaking English" do |message|
    message.channels= ["#Finnish"]
    message.users= ["John"]
    message.kick_message= "Speaking English"
  end

  it_generates IRCParser::Messages::Kick, ":WiZ KICK #Finnish John" do |message|
    message.prefix= "WiZ"
    message.channels= ["#Finnish"]
    message.users= ["John"]
  end
end
