module ParsingHelper

  def it_parses(raw_message, &block)
    it("parses #{raw_message.inspect}") do
      message = IRCParser.parse(raw_message << "\r\n")
      instance_exec(message, &block)
    end
  end

  def it_generates(klass, gen_message, &block)
    it("generates #{gen_message}") do
      begin
        message = klass.new(nil)
        instance_exec(message, &block)
        message.to_s.should == "#{gen_message}\r\n"
      rescue => e
        puts e
        puts e.backtrace.join("\n")
        raise e
      end
    end
  end

end
