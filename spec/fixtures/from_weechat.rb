require 'set'

inbound = Set.new
outbound = Set.new

def normalize(line, sep)
  line = line.split(sep)[1..-1].join.chomp
end

IO.foreach("raw.log") do |line|
  if line =~ / --> /
    inbound << normalize(line, " --> ")
  elsif line =~ / <-- /
    outbound << normalize(line, " <-- ")
  end
end

File.open("inbound.log", "w") do |fin|
  fin << inbound.to_a.sort.join("\n")
end

File.open("outbound.log", "w") do |fout|
  fout << outbound.to_a.sort.join("\n")
end
