require 'spec_helper'
require 'irc_parser/messages'

describe IRCParser::Messages, "in general" do
  it "raises an exception on bad message" do |message|
    expect { IRCParser.parse("fail\r\n") }.to raise_error(IRCParser::Parser::Error)
    expect { IRCParser.parse("LALALA nick\r\n") }.to raise_error(IRCParser::Parser::Error)
    expect { IRCParser.parse("PASS nick\r\n") }.to_not raise_error(IRCParser::Parser::Error)
  end
end
