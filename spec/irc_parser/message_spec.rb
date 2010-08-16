require 'spec_helper'

describe IRCParser::Messages, "in general" do
  it "raises an exception on bad message" do |message|
    lambda { IRCParser.parse("fail") }.should raise_error(IRCParser::Parser::Error)
    lambda { IRCParser.parse("LALALA nick") }.should raise_error(IRCParser::Parser::Error)
  end

  it "can return several messages at once" do
    j, m = IRCParser.messages(:join, :mode)
    j.should be_an_instance_of(IRCParser::Messages::Join)
    m.should be_an_instance_of(IRCParser::Messages::Mode)
  end

  it "can return several errors at once" do
    t, n = IRCParser.errors(:too_many_targets, :no_origin)
    t.should be_an_instance_of(IRCParser::Messages::ErrTooManyTargets)
    n.should be_an_instance_of(IRCParser::Messages::ErrNoOrigin)
  end

  it "can return several replies at once" do
    s, m, f = IRCParser.replies(:motd_start, :motd, :end_of_motd)
    s.should be_an_instance_of(IRCParser::Messages::RplMotdStart)
    m.should be_an_instance_of(IRCParser::Messages::RplMotd)
    f.should be_an_instance_of(IRCParser::Messages::RplEndOfMotd)
  end

  it "evaluates something in the context of a selected reply" do
    IRCParser.reply_class_eval(:motd_start) do
      def something_new
      end
    end

    IRCParser.reply(:motd_start).should respond_to(:something_new)
  end

  it "evaluates something in the context of a selected error" do
    IRCParser.error_class_eval(:too_many_targets) do
      def something_new
      end
    end

    IRCParser.error(:too_many_targets).should respond_to(:something_new)
  end

  it "evaluates something in the context of a selected message" do
    IRCParser.message_class_eval(:join) do
      def something_new
      end
    end

    IRCParser.message(:join).should respond_to(:something_new)
  end

end
