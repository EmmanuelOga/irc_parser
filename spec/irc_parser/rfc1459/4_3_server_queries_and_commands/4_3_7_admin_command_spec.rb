require 'spec_helper'

describe IRCParser, "parsing admin command" do

  # ; request an ADMIN reply from tolsun.oulu.fi
  it_parses "ADMIN tolsun.oulu.fi" do |msg|
    msg.target.should == "tolsun.oulu.fi"
  end

  # ; ADMIN request from WiZ for first target found to match *.edu.
  it_parses ":WiZ ADMIN *.edu" do |msg|
    msg.prefix.should == "WiZ"
    msg.target.should == "*.edu"
  end

  #------------------------------------------------------------------------------

  # ; request an ADMIN reply from tolsun.oulu.fi
  it_generates IRCParser::Messages::Admin, "ADMIN tolsun.oulu.fi" do |msg|
    msg.target= "tolsun.oulu.fi"
  end

  # ; ADMIN request from WiZ for first target found to match *.edu.
  it_generates IRCParser::Messages::Admin, ":WiZ ADMIN *.edu" do |msg|
    msg.prefix= "WiZ"
    msg.target= "*.edu"
  end
end
