require 'spec_helper'

describe IRCParser, "parsing who query" do
  # Parameters: [<name> [<o>]]

  # ; List all users who match against "*.fi".
  it_parses "WHO *.fi" do |msg|
    msg.pattern.should == "*.fi"
  end

  # ; List all users with a match against "jto*" if they are an operator.
  it_parses "WHO jto* o" do |msg|
    msg.pattern.should == "jto*"
    msg.should be_operator
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Who, "WHO *.fi" do |msg|
    msg.pattern= "*.fi"
  end

  it_generates IRCParser::Messages::Who, "WHO jto* o" do |msg|
    msg.pattern= "jto*"
    msg.operator!
  end
end
