require 'spec_helper'

describe IRCParser, "parsing operwall message" do

  # ; WALLOPS message from csd.bu.edu announcing a CONNECT message it received and acted upon from Joshua.
  it_parses ":csd.bu.edu WALLOPS :Connect '*.uiuc.edu 6667' from Joshua" do |message|
    message.from.should == "csd.bu.edu"
    message.wall_message.should == "Connect '*.uiuc.edu 6667' from Joshua"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::WallOps, ":csd.bu.edu WALLOPS :Connect '*.uiuc.edu 6667' from Joshua" do |message|
    message.from= "csd.bu.edu"
    message.wall_message= "Connect '*.uiuc.edu 6667' from Joshua"
  end
end
