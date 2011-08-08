require 'irc_parser'
require 'benchmark'

MSG1 = "200 Wiz Link 1.10 destination.com next_server.net\r\n"
MSG2 = "PRIVMSG #*.edu :NSFNet is undergoing work, expect interruptions\r\n"

IRCMessage = IRCParser.message(:priv_msg) do |msg|
  msg.prefix= "Angel"
  msg.target= "Wiz"
  msg.body= "Hello are you receiving this message ?"
end.to_s

$BEFORE_BENCHMARK = `ps -Orss -p #{$$}`.split[7].to_i

Benchmark.bmbm do |rep|
  rep.report("parsing / generation") do
    10_000.times do
      IRCParser.parse(MSG1).to_s
      IRCParser.parse(MSG2).to_s
    end
    10_000.times do
      IRCParser.message(:priv_msg) do |msg|
        msg.prefix= "Angel"
        msg.target= "Wiz"
        msg.body= "Hello are you receiving this message ?"
      end.to_s
    end
  end

  rep.report("generation") do
    20_000.times do
      IRCMessage.to_s
    end
  end
end

at_exit do
  $AFTER_BENCHMARK = `ps -Orss -p #{$$}`.split[7].to_i

  puts "Used: " << ($AFTER_BENCHMARK - $BEFORE_BENCHMARK).to_s << " Kilobytes."
end
