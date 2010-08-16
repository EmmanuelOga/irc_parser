require 'spec_helper'

describe IRCParser, "parsing admin command" do

  # ; request an ADMIN reply from tolsun.oulu.fi
  it_parses "ADMIN tolsun.oulu.fi" do |message|
    message.server.should == "tolsun.oulu.fi"
  end

  # ; ADMIN request from WiZ for first server found to match *.edu.
  it_parses ":WiZ ADMIN *.edu" do |message|
    message.prefix.should == "WiZ"
    message.server.should == "*.edu"
  end

  #------------------------------------------------------------------------------

  # ; request an ADMIN reply from tolsun.oulu.fi
  it_generates IRCParser::Messages::Admin, "ADMIN tolsun.oulu.fi" do |message|
    message.server= "tolsun.oulu.fi"
  end

  # ; ADMIN request from WiZ for first server found to match *.edu.
  it_generates IRCParser::Messages::Admin, ":WiZ ADMIN *.edu" do |message|
    message.prefix= "WiZ"
    message.server= "*.edu"
  end
end
