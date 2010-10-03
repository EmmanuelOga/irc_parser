require 'spec_helper'

describe IRCParser::Params do
  it "accepts defaults" do
    IRCParser::Params.new([1,2,3]).should == [1,2,3]
  end

  it "accepts other parameters" do
    IRCParser::Params.new([1,2,3], [4, 5]).should == [4,5,3]
  end

  it "generates an empty string for empty params" do
    IRCParser::Params.new([]).to_s.should == ""
  end

  it "generates a string based on the number of postfixes" do
    IRCParser::Params.new([1,2,3]).to_s.should == "1 2 3"
    IRCParser::Params.new([1,2,3]).to_s(1).should == "1 2 :3"
    IRCParser::Params.new([1,2,3]).to_s(2).should == "1 :2 3"
    IRCParser::Params.new([1,2,3]).to_s(3).should == ":1 2 3"
  end
end
