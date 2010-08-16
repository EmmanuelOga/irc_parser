require 'spec_helper'

describe IRCParser, "parsing quit" do

  it_parses "QUIT :Gone to have lunch" do |message|
    message.quit_message.should == "Gone to have lunch"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Quit, "QUIT :Gone to have lunch" do |message|
    message.quit_message= "Gone to have lunch"
  end

end
