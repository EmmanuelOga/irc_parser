require 'spec_helper'

describe IRCParser::Parser do
  it "raises an exception on bad msg" do |message|
    expect { IRCParser.parse("fail\r\n") }.to raise_error(IRCParser::Parser::Error)
    expect { IRCParser.parse("LALALA nick\r\n") }.to raise_error(IRCParser::Parser::Error)
    expect { IRCParser.parse("PASS nick\r\n") }.to_not raise_error(IRCParser::Parser::Error)
  end
end
