require 'spec_helper'

describe IRCParser, "parsing oper" do

  it_parses "OPER foo bar" do |message|
    message.user.should == "foo"
    message.password.should == "bar"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Oper, "OPER foo bar" do |message|
    message.user= "foo"
    message.password= "bar"
  end

end
