require 'spec_helper'

describe IRCParser, "parsing whois query" do
  # Parameters: [<server>] <nickpattern>[,<nickpattern>[,...]]

  # ; return available user information about nick WiZ
  it_parses "WHOIS wiz" do |msg|
    msg.pattern.should == "wiz"
  end

  # ; ask server eff.org for user information about trillian
  it_parses "WHOIS eff.org trillian" do |msg|
    msg.target.should == "eff.org"
    msg.pattern.should == "trillian"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::WhoIs, "WHOIS wiz" do |msg|
    msg.target= "wiz"
  end

  it_generates IRCParser::Messages::WhoIs, "WHOIS eff.org trillian" do |msg|
    msg.target= "eff.org"
    msg.pattern= "trillian"
  end
end
