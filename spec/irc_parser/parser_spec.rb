require 'spec_helper'

describe IRCParser, "parser" do
  it "raises an exception on bad msg" do |message|
    expect { IRCParser.parse("fail\r\n") }.to raise_error(IRCParser::ParserError)
    expect { IRCParser.parse("LALALA nick\r\n") }.to raise_error(IRCParser::ParserError)
    expect { IRCParser.parse("PASS nick\r\n") }.to_not raise_error(IRCParser::ParserError)
  end
end
