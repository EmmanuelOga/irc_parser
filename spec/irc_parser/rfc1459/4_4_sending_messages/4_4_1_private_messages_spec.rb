require 'spec_helper'

describe IRCParser, "parsing private msgs" do

  # ; Message from Angel to Wiz.
  it_parses ":Angel PRIVMSG Wiz :Hello are you receiving this message ?" do |msg|
    msg.prefix.should == "Angel"
    msg.target.should == "Wiz"
    msg.body.should == "Hello are you receiving this message ?"
  end

  # ; Message to Angel.
  it_parses "PRIVMSG Angel :yes I'm receiving it !receiving it !'u>(768u+1n) .br" do |msg|
    msg.target.should == "Angel"
    msg.body.should == "yes I'm receiving it !receiving it !'u>(768u+1n) .br"
  end

  # ; Message to a client on server tolsun.oulu.fi with username of "jto".
  it_parses "PRIVMSG jto@tolsun.oulu.fi :Hello !" do |msg|
    msg.target.should == "jto@tolsun.oulu.fi"
    msg.body.should == "Hello !"
  end

  # ; Message to everyone on a server which has a name matching *.fi.
  it_parses "PRIVMSG $*.fi :Server tolsun.oulu.fi rebooting." do |msg|
    msg.server_pattern.should == /.*\.fi/
    msg.body.should == "Server tolsun.oulu.fi rebooting."
  end

  # ; Message to all users who come from a host which has a name matching *.edu.
  it_parses "PRIVMSG #*.edu :NSFNet is undergoing work, expect interruptions" do |msg|
    msg.host_pattern.should == /.*\.edu/
    msg.body.should == "NSFNet is undergoing work, expect interruptions"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::PrivMsg, ":Angel PRIVMSG Wiz :Hello are you receiving this message ?" do |msg|
    msg.prefix= "Angel"
    msg.target= "Wiz"
    msg.body= "Hello are you receiving this message ?"
  end

  it_generates IRCParser::Messages::PrivMsg, "PRIVMSG Angel :yes I'm receiving it !receiving it !'u>(768u+1n) .br" do |msg|
    msg.target= "Angel"
    msg.body= "yes I'm receiving it !receiving it !'u>(768u+1n) .br"
  end

  it_generates IRCParser::Messages::PrivMsg, "PRIVMSG jto@tolsun.oulu.fi :Hello !" do |msg|
    msg.target= "jto@tolsun.oulu.fi"
    msg.body= "Hello !"
  end

  it_generates IRCParser::Messages::PrivMsg, "PRIVMSG $*.fi :Server tolsun.oulu.fi rebooting." do |msg|
    msg.server_pattern= "$*.fi"
    msg.body= "Server tolsun.oulu.fi rebooting."
  end

  it_generates IRCParser::Messages::PrivMsg, "PRIVMSG #*.edu :NSFNet is undergoing work, expect interruptions" do |msg|
    msg.host_pattern= "#*.edu"
    msg.body= "NSFNet is undergoing work, expect interruptions"
  end
end
