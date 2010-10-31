require 'spec_helper'

describe IRCParser, "parsing user msg" do

  it_parses "USER guest tolmoon tolsun :Ronnie Reagan" do |msg|
    msg.hostname.should   == "tolmoon"
    msg.mode.should       == "tolmoon"
    msg.real_name.should  == "Ronnie Reagan"
    msg.servername.should == "tolsun"
    msg.user.should       == "guest"
  end

  it_parses ":testnick USER guest tolmoon tolsun :Ronnie Reagan" do |msg|
    msg.hostname.should   == "tolmoon"
    msg.mode.should       == "tolmoon"
    msg.prefix.should     == "testnick"
    msg.real_name.should  == "Ronnie Reagan"
    msg.servername.should == "tolsun"
    msg.user.should       == "guest"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::User, "USER guest tolmoon tolsun :Ronnie Reagan" do |msg|
    msg.hostname= "tolmoon"
    msg.mode= "tolmoon"
    msg.real_name= "Ronnie Reagan"
    msg.servername= "tolsun"
    msg.user= "guest"
  end

  it_generates IRCParser::Messages::User, ":testnick USER guest tolmoon tolsun :Ronnie Reagan" do |msg|
    msg.servername= "tolsun"
    msg.mode= "tolmoon"
    msg.prefix= "testnick"
    msg.real_name= "Ronnie Reagan"
    msg.user= "guest"
  end

  it_generates IRCParser::Messages::User, "USER guest * * :Ronnie Reagan" do |msg|
    msg.real_name= "Ronnie Reagan"
    msg.user= "guest"
  end

  it_generates IRCParser::Messages::User, ":testnick USER guest * * :Ronnie Reagan" do |msg|
    msg.prefix= "testnick"
    msg.user= "guest"
    msg.real_name= "Ronnie Reagan"
  end
end
