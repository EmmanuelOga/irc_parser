require 'spec_helper'

describe IRCParser, "parsing links message" do

  # ; list all servers which have a name that matches *.au;
  it_parses "LINKS *.au" do |message|
    message.server_mask.should == "*.au"
  end

  # ; LINKS message from WiZ to the first server matching *.edu for a list of servers matching *.bu.edu.
  it_parses ":WiZ LINKS *.bu.edu *.edu" do |message|
    message.from.should == "WiZ"
    message.remote_server.should == "*.bu.edu"
    message.server_mask.should == "*.edu"
  end

  #------------------------------------------------------------------------------

  # ; list all servers which have a name that matches *.au;
  it_generates IRCParser::Messages::Links, "LINKS *.au" do |message|
    message.server_mask= "*.au"
  end

  # ; LINKS message from WiZ to the first server matching *.edu for a list of servers matching *.bu.edu.
  it_generates IRCParser::Messages::Links, ":WiZ LINKS *.bu.edu *.edu" do |message|
    message.from= "WiZ"
    message.remote_server= "*.bu.edu"
    message.server_mask= "*.edu"
  end

end
