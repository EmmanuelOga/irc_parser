require 'spec_helper'

describe IRCParser, "parsing restart msg" do
  # Parameters: None

  it_parses "RESTART" do
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Restart, "RESTART" do
  end
end

