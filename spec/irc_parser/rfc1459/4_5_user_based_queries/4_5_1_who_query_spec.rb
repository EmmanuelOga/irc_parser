require 'spec_helper'

describe IRCParser, "parsing who query" do
  # Parameters: [<name> [<o>]]

  # ; List all users who match against "*.fi".
  it_parses "WHO *.fi" do |message|
    message.pattern.should == "*.fi"
  end

  # ; List all users with a match against "jto*" if they are an operator.
  it_parses "WHO jto* o" do |message|
    message.pattern.should == "jto*"
    message.should be_operator
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Who, "WHO *.fi" do |message|
    message.pattern= "*.fi"
  end

  it_generates IRCParser::Messages::Who, "WHO jto* o" do |message|
    message.pattern= "jto*"
    message.operator!
  end
end
