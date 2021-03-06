require 'spec_helper'

describe IRCParser, "parsing quit" do

  it_parses ":some_nick!some_user@some_server QUIT :Gone to have lunch" do |msg|
    msg.prefix.should == "some_nick!some_user@some_server"
    msg.quit_message.should == "Gone to have lunch"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Quit, ":some_nick!some_user@some_server QUIT :Gone to have lunch" do |msg|
    msg.prefix = "some_nick!some_user@some_server"
    msg.quit_message= "Gone to have lunch"
  end

end
