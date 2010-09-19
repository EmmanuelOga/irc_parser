module ParsingHelper

  def it_parses(raw_message, &block)
    it("parses #{raw_message.inspect}") do
      raw_with_newline = raw_message << "\r\n"
      begin
        message = IRCParser.parse(raw_with_newline)
      rescue => e
        ap e.backtrace
        failed = e # rescue to allow pending specs
      end

      begin
        instance_exec(message, &block)
      rescue => e
        second = e
      end

      if failed || second
        raise failed || second
      else
        message.to_s.should == raw_with_newline
      end
    end
  end

  def it_generates(klass, gen_message, &block)
    it("generates #{gen_message}") do
      begin
      message = klass.new(nil)
      instance_exec(message, &block)
      message.to_s.should == "#{gen_message}\r\n"
      rescue => e
        ap e
        ap e.backtrace
        raise e
      end
    end
  end

end
