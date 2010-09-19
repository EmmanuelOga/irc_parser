module IRCParser
  class Params < Array
    attr_reader :postfixes

    PLACEHOLDER = Object.new.tap {|o| def o.inspect; "<PLACEHOLDER>"; end }.freeze

    # Params is an array of values
    # Postfixes is the number of paremeters used to build the last parameter
    def initialize(params, postfixes)
      replace(params)
      @postfixes = postfixes || 0
    end

    def remove_placeholders
      dup.tap do |ret|
        ret.delete_if { |val| val == PLACEHOLDER }
      end
    end

    # The message has a number of postfixes, which are the paremeters to be
    # joined in the last parameter. This is because the RFC protocol only
    # allows blank on the last param.  All the parameters are joined by a
    # space.
    def to_s
      return "" if empty? || (length == 1 && first == PLACEHOLDER)

      parameters = dup
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
