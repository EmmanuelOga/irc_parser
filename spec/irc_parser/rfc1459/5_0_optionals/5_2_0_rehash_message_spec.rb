require 'spec_helper'

describe IRCParser, "parsing rehash msg" do
  # Parameters: None

  # ; msg from client with operator status to server asking it to reread its configuration file.
  it_parses "REHASH" do
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::Rehash, "REHASH" do
  end
end
