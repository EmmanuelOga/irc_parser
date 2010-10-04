module IRCParser
  class Params < Array

    # Params is an array of values
    def initialize(defaults, params = nil)
      replace(defaults)

      if params
        length = params.length
        self[length] = params[length] while (length -= 1) >= 0
      end
    end

    # Postfixes is the number of paremeters used to build the last parameter
    # The message has a number of postfixes, which are the paremeters to be
    # joined in the last parameter. This is because the RFC protocol only
    # allows blank on the last param.  All the parameters are joined by a
    # space.
    def to_s(minimum_postfixes = 0)
      if empty? || self == EMPTY_PARAM
        ""
      else
        postfixes = length
        postfixes -= 1 while postfixes > minimum_postfixes && self[-postfixes].to_s !~ /\s/

        prefix, postfix = self[0, length - postfixes], self[-postfixes, postfixes]
        prefix.delete(nil); postfix.delete(nil)

        "#{" #{prefix.join(" ")}" unless prefix.empty?}#{" :#{postfix.join(" ")}" unless postfix.empty?}"
      end
    end

    EMPTY_PARAM = [""].freeze
  end
end
