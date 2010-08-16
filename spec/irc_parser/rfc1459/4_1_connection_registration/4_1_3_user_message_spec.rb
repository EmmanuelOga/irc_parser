require 'spec_helper'

describe IRCParser, "parsing user message" do

  it_parses "USER guest tolmoon tolsun :Ronnie Reagan" do |message|
    message.hostname.should   == "tolmoon"
    message.mode.should       == "tolmoon"
    message.real_name.should   == "Ronnie Reagan"
    message.servername.should == "tolsun"
    message.unused.should     == "tolsun"
    message.user.should       == "guest"
  end

  it_parses ":testnick USER guest tolmoon tolsun :Ronnie Reagan" do |message|
    message.hostname.should   == "tolmoon"
    message.mode.should       == "tolmoon"
    message.prefix.should     == "testnick"
    message.real_name.should   == "Ronnie Reagan"
    message.servername.should == "tolsun"
    message.unused.should     == "tolsun"
    message.user.should       == "guest"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::User, "USER guest tolmoon tolsun :Ronnie Reagan" do |message|
    message.hostname= "tolmoon"
    message.mode= "tolmoon"
    message.real_name= "Ronnie Reagan"
    message.servername= "tolsun"
    message.unused= "tolsun"
    message.user= "guest"
  end

  it_generates IRCParser::Messages::User, ":testnick USER guest tolmoon tolsun :Ronnie Reagan" do |message|
    message.hostname= "tolmoon"
    message.mode= "tolmoon"
    message.prefix= "testnick"
    message.real_name= "Ronnie Reagan"
    message.servername= "tolsun"
    message.unused= "tolsun"
    message.user= "guest"
  end
end
