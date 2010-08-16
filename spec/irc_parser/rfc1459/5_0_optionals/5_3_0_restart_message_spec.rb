require 'spec_helper'

describe IRCParser, "parsing restart message" do
  # Parameters: None

  it_parses "RESTART" do
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Restart, "RESTART" do
  end
end

