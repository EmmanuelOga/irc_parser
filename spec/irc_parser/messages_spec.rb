require 'spec_helper'
describe IRCParser::Messages do
  context "Factories" do

    context "in general" do
      context "commands" do
        SomeCommand = IRCParser::Messages.message_class(:SomeCommand)
        subject { SomeCommand  }

        its(:name)           { should == :SomeCommand }
        its(:to_sym)         { should == :some_command }
        its(:identifier)     { should == :SOMECOMMAND }
        its(:postfix_format) { should == nil }
        its(:is_error?)      { should be_false }
        its(:is_reply?)      { should be_false }
        its(:is_command?)    { should be_true }
      end

      context "errors" do
        ErrSomeError = IRCParser::Messages.message_class(:ErrSomeError, "1400")
        subject { ErrSomeError }

        its(:name)           { should == :ErrSomeError }
        its(:to_sym)         { should == :err_some_error }
        its(:identifier)     { should == :"1400" }
        its(:postfix_format) { should == nil }
        its(:is_error?)      { should be_true }
        its(:is_reply?)      { should be_false }
        its(:is_command?)    { should be_false }
      end

      context "replies" do
        RplSomeReply = IRCParser::Messages.message_class(:RplSomeReply, "1300")
        subject { RplSomeReply }

        its(:name)           { should == :RplSomeReply }
        its(:to_sym)         { should == :rpl_some_reply }
        its(:identifier)     { should == :"1300" }
        its(:postfix_format) { should == nil }
        its(:is_error?)      { should be_false }
        its(:is_reply?)      { should be_true }
        its(:is_command?)    { should be_false }
      end
    end

    context "parameter-less messages" do
      ParamLess = IRCParser::Messages.message_class :ParamLess

      let(:message) { ParamLess.new }

      it "generates a parameter-less message" do
        message.to_s.should == "PARAMLESS\r\n"
      end

      it "generates a parameter-less message with prefix" do
        message.prefix = "someone"
        message.to_s.should == ":someone PARAMLESS\r\n"
      end

      it "generates a parameter-less message with postfix" do
        message.postfix = "something cool"
        message.to_s.should == "PARAMLESS :something cool\r\n"
      end

      it "generates a parameter-less message with prefix and postfix" do
        message.prefix = "someone"
        message.postfix = "something cool"
        message.to_s.should == ":someone PARAMLESS :something cool\r\n"
      end
    end

    context "one parameter" do
      OneParam = IRCParser::Messages.message_class :OneParam, :nick

      let(:message) { OneParam.new "", ["Tony"] }

      it "generates a message with one parameter" do
        message.to_s.should == "ONEPARAM Tony\r\n"
      end

      it "generates a message with prefix" do
        message.prefix = "someone"
        message.to_s.should == ":someone ONEPARAM Tony\r\n"
      end

      it "generates a message with postfix" do
        message.postfix = "something cool"
        message.to_s.should == "ONEPARAM Tony :something cool\r\n"
      end

      it "generates a message with prefix and postfix" do
        message.prefix = "someone"
        message.postfix = "something cool"
        message.to_s.should == ":someone ONEPARAM Tony :something cool\r\n"
      end
    end

    context "two parameters" do
      TwoParams = IRCParser::Messages.message_class :TwoParams, {:nick => {:default => "*"}}, :name

      let(:message) { TwoParams.new "", ["Tony", "Motola"] }

      it "defaults to * for missing fields with defaults" do
        TwoParams.new.to_s.should == "TWOPARAMS *\r\n"
        TwoParams.new("", ["Moncho", nil]).to_s.should == "TWOPARAMS Moncho\r\n"
        TwoParams.new("", ["", "Moncho"]).to_s.should == "TWOPARAMS * Moncho\r\n"
      end

      it "generates a message with one parameter" do
        message.to_s.should == "TWOPARAMS Tony Motola\r\n"
      end

      it "generates a message with prefix" do
        message.prefix = "someone"
        message.to_s.should == ":someone TWOPARAMS Tony Motola\r\n"
      end

      it "generates a with postfix" do
        message.postfix = "something cool"
        message.to_s.should == "TWOPARAMS Tony Motola :something cool\r\n"
      end

      it "generates a message with prefix and postfix" do
        message.prefix = "someone"
        message.postfix = "something cool"
        message.to_s.should == ":someone TWOPARAMS Tony Motola :something cool\r\n"
      end
    end

    context "parameters with configuration" do
      WithConfig = IRCParser::Messages.message_class :WithConfig, {:nick => {:default => "Titus"}}, {:names => {:csv => " "}}

      let(:message) { WithConfig.new "", ["", ["Tito", "Puente"]] }

      it "generates a message with the defaults fill up" do
        message.to_s.should == "WITHCONFIG Titus Tito Puente\r\n"
      end

      it "generates a message with prefix" do
        message.prefix = "someone"
        message.to_s.should == ":someone WITHCONFIG Titus Tito Puente\r\n"
      end

      it "generates a message with postfix" do
        message.postfix = "something cool"
        message.to_s.should == "WITHCONFIG Titus Tito Puente :something cool\r\n"
      end

      it "generates a message with prefix and postfix" do
        message.prefix = "someone"
        message.postfix = "something cool"
        message.to_s.should == ":someone WITHCONFIG Titus Tito Puente :something cool\r\n"
      end
    end

    context "defining classes" do
      IRCParser::Messages.define_message(:MyCommand)
      IRCParser::Messages.define_message(:ErrMyErr, "1200")
      IRCParser::Messages.define_message(:RplMyRpl, "1600")

      it "defines classes in the Messages namespace" do
        defined?(IRCParser::Messages::MyCommand).should be_true
        defined?(IRCParser::Messages::ErrMyErr).should be_true
        defined?(IRCParser::Messages::RplMyRpl).should be_true
      end

      it "is able to retrieve the classes with different keys" do
        IRCParser.message_class(:"MyCommand"). should == IRCParser::Messages::MyCommand
        IRCParser.message_class(:"MYCOMMAND"). should == IRCParser::Messages::MyCommand
        IRCParser.message_class(:my_command).  should == IRCParser::Messages::MyCommand
        IRCParser.message_class("my_command"). should == IRCParser::Messages::MyCommand
        IRCParser.message_class("MYCOMMAND").  should == IRCParser::Messages::MyCommand

        IRCParser.message_class(:"ERRMYERR").  should == IRCParser::Messages::ErrMyErr
        IRCParser.message_class(:"ErrMyErr").  should == IRCParser::Messages::ErrMyErr
        IRCParser.message_class(:err_my_err).  should == IRCParser::Messages::ErrMyErr
        IRCParser.message_class("ERRMYERR").   should == IRCParser::Messages::ErrMyErr
        IRCParser.message_class("ErrMyErr").   should == IRCParser::Messages::ErrMyErr
        IRCParser.message_class("err_my_err"). should == IRCParser::Messages::ErrMyErr
        IRCParser.message_class("1200").       should == IRCParser::Messages::ErrMyErr
        IRCParser.message_class(1200).         should == IRCParser::Messages::ErrMyErr

        IRCParser.message_class(:"RPLMYRPL").  should == IRCParser::Messages::RplMyRpl
        IRCParser.message_class(:"RplMyRpl").  should == IRCParser::Messages::RplMyRpl
        IRCParser.message_class(:rpl_my_rpl).  should == IRCParser::Messages::RplMyRpl
        IRCParser.message_class("RPLMYRPL").   should == IRCParser::Messages::RplMyRpl
        IRCParser.message_class("RplMyRpl").   should == IRCParser::Messages::RplMyRpl
        IRCParser.message_class("rpl_my_rpl"). should == IRCParser::Messages::RplMyRpl
        IRCParser.message_class("1600").       should == IRCParser::Messages::RplMyRpl
        IRCParser.message_class(1600).         should == IRCParser::Messages::RplMyRpl
      end
    end

  end
end
