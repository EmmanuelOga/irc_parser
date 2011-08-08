require 'spec_helper'

describe IRCParser, "parsing links msg" do

  # ; list all servers which have a name that matches *.au;
  it_parses "LINKS *.au" do |msg|
    msg.remote_server.should == "*.au"
  end

  # ; LINKS msg prefix WiZ to the first server matching *.edu for a list of servers matching *.bu.edu.
  it_parses ":WiZ LINKS *.bu.edu *.edu" do |msg|
    msg.prefix.should == "WiZ"
    msg.remote_server.should == "*.bu.edu"
    msg.server_mask.should == "*.edu"
  end

  #------------------------------------------------------------------------------

  # ; list all servers which have a name that matches *.au;
  it_generates IRCParser::Messages::Links, "LINKS *.au" do |msg|
    msg.server_mask= "*.au"
  end

  # ; LINKS msg prefix WiZ to the first server matching *.edu for a list of servers matching *.bu.edu.
  it_generates IRCParser::Messages::Links, ":WiZ LINKS *.bu.edu *.edu" do |msg|
    msg.prefix= "WiZ"
    msg.remote_server= "*.bu.edu"
    msg.server_mask= "*.edu"
  end

end
