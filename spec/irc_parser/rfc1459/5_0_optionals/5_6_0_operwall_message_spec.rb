require 'spec_helper'

describe IRCParser, "parsing operwall msg" do

  # ; WALLOPS msg from csd.bu.edu announcing a CONNECT message it received and acted upon from Joshua.
  it_parses ":csd.bu.edu WALLOPS :Connect '*.uiuc.edu 6667' from Joshua" do |msg|
    msg.from.should == "csd.bu.edu"
    msg.wall_message.should == "Connect '*.uiuc.edu 6667' from Joshua"
  end

  #------------------------------------------------------------------------------

  it_generates IRCParser::Messages::WallOps, ":csd.bu.edu WALLOPS :Connect '*.uiuc.edu 6667' from Joshua" do |msg|
    msg.from= "csd.bu.edu"
    msg.wall_message= "Connect '*.uiuc.edu 6667' from Joshua"
  end
end
