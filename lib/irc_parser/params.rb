module IRCParser
  class Params < Array
    PLACEHOLDER = Object.new.tap {|o| def o.inspect; "<PLACEHOLDER>"; end }.freeze

    # Params is an array of values
    def initialize(params)
      replace(params)
    end

    # The message has a number of postfixes, which are the paremeters to be
    # joined in the last parameter. This is because the RFC protocol only
    # allows blank on the last param.  All the parameters are joined by a
    # space.
    # Postfixes is the number of paremeters used to build the last parameter
    def to_s(_postfixes)
      postfixes = _postfixes || 0
      return "" if empty? || (length == 1 && (first.nil? || first == ""))

      parameters = reject {|elem| elem.nil? } #dup
      parameters.pop while parameters.last == PLACEHOLDER # don't send unneeded wildcards
      parameters = parameters.map { |val| val == PLACEHOLDER ? "*" : val }

      # With 0 postfixes we might still want to check if the last one has
      # spaces, because in that case we need to put the colon in the last param
      # even if it is not a postfix.
      last = []
      (postfixes == 0 ? 1 : postfixes).times do
        param = parameters.pop
        last.unshift param
      end

      last = last.flatten.join(" ")

      parameters.push(last == "" || last.nil? || last =~ /\s+/ || postfixes > 0 ? ":#{last}" : last)

      parameters.join(" ") || ""
    end
  end
end
