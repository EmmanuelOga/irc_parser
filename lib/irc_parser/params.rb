module IRCParser
  class Params < Array
    PLACEHOLDER = Object.new.tap {|o| def o.inspect; "<PLACEHOLDER>"; end }.freeze

    # Params is an array of values
    def initialize(defaults, *params)
      replace(defaults)
      params.each_with_index { |elem, index| self[index] = elem }
    end

    # Postfixes is the number of paremeters used to build the last parameter
    # The message has a number of postfixes, which are the paremeters to be
    # joined in the last parameter. This is because the RFC protocol only
    # allows blank on the last param.  All the parameters are joined by a
    # space.
    def to_s(postfixes = 0)
      return "" if empty? || (length == 1 && (first.nil? || first == ""))

      parameters = reject {|elem| elem.nil? }
      parameters.pop while parameters.last == PLACEHOLDER # don't send unneeded wildcards
      parameters = parameters.map { |val| val == PLACEHOLDER ? "*" : val }

      split_index = postfixes.nil? || postfixes == 0 ? 1 : postfixes
      parameters, last = Array(parameters[0...-split_index]), Array(parameters[-split_index..-1]).flatten.join(" ")
      parameters.push(last == "" || last.nil? || last =~ /\s+/ || (postfixes && postfixes > 0) ? ":#{last}" : last)

      parameters.join(" ") || ""
    end
  end
end
