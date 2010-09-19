require 'spec_helper'

describe IRCParser, "parsing whois query" do
  # Parameters: [<server>] <nickpattern>[,<nickpattern>[,...]]

  # ; return available user information about nick WiZ
  it_parses "WHOIS wiz" do |message|
    ap message
    message.pattern.should == "wiz"
  end

  # ; ask server eff.org for user information about trillian
  it_parses "WHOIS eff.org trillian" do |message|
    message.target.should == "eff.org"
    message.pattern.should == "trillian"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::WhoIs, "WHOIS wiz" do |message|
    message.target= "wiz"
  end

  it_generates IRCParser::Messages::WhoIs, "WHOIS eff.org trillian" do |message|
    message.target= "eff.org"
    message.pattern= "trillian"
  end
end
