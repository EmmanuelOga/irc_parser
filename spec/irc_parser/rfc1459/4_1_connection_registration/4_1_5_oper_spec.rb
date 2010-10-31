require 'spec_helper'

describe IRCParser, "parsing oper" do

  it_parses "OPER foo bar" do |msg|
    msg.user.should == "foo"
    msg.password.should == "bar"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Oper, "OPER foo bar" do |msg|
    msg.user= "foo"
    msg.password= "bar"
  end

end
