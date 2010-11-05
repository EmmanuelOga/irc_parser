require 'spec_helper'

describe IRCParser do
  it "provides a helper method to generate messages" do
    IRCParser.message("MODE", nil, ["nick"]).to_s.should == "MODE nick\r\n"
    IRCParser.message("MODE") { |msg| msg.target = "nick" }.to_s.should == "MODE nick\r\n"
  end

  it "provides a helper method to generate messages" do
    IRCParser.message("PASS") { |msg| msg.password = "pass" }.to_s.should == "PASS pass\r\n"
  end
end
