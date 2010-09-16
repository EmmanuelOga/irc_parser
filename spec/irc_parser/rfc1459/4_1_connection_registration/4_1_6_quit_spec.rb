require 'spec_helper'

describe IRCParser, "parsing quit" do

  it_parses ":some_nick!some_user@some_server QUIT :Gone to have lunch" do |message|
    message.prefix.should == "some_nick!some_user@some_server"
    message.quit_message.should == "Gone to have lunch"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Quit, ":some_nick!some_user@some_server QUIT :Gone to have lunch" do |message|
    message.prefix = "some_nick!some_user@some_server"
    message.quit_message= "Gone to have lunch"
  end

end
