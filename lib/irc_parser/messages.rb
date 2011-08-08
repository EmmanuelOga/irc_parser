require 'erb'

module IRCParser
  module Messages
    # Store all known message classes under convenient keys so they are easy to find.
    ALL = Hash.new

    # Create a Message class and save it on the IRCParser::Messages::ALL hash
    # for easy retrieval with different names.
    def self.define_message(name, *arguments, &block)
      klass = message_class(name, *arguments, &block)
      [klass.name.to_s, klass.name.to_s.upcase, klass.to_sym.to_s, klass.to_sym.to_s.upcase, klass.identifier.to_s].uniq.each do |key|
        IRCParser::Messages::ALL[key] = klass
        IRCParser::Messages::ALL[key.to_sym] = klass
      end
      IRCParser::Messages::ALL[klass.identifier.to_s.to_i] = klass if klass.identifier.to_s =~ /^\d+$/
      const_set(name, klass)
    end

    IMPLEMENTATION_PATH = File.expand_path(File.join(File.dirname(__FILE__), "factory.erb"))
    IMPLEMENTATION = File.read(IMPLEMENTATION_PATH)

    # Creates a message class, which inherits from a ruby Struct to save the different message params.
    def self.message_class(name, *arguments, &block)
      # # #
      # Prepare information needed to generate the classes
      # # #

      # klass.to_sym is convenient name for storing the class in the ALL hash. E.g.: AWAY -> :away
      to_sym = IRCParser::Helper.underscore(name).to_sym
      identifier = (arguments.first.is_a?(String) ? arguments.shift : name).to_s.upcase.to_sym
      postfix_format = arguments.pop if arguments.last.is_a?(String)
      postfix_alias = arguments.pop.keys.first if arguments.last.is_a?(Hash) && arguments.last.values.first == :postfix

      placeholders = 0 # used to give name to placeholder arguments.

      # normalize the parameter information so it is easy to work with.
      arguments.map! do |arg|
        if arg.is_a?(Hash)      then {:name => arg.keys.first}.merge(arg.values.first)
        elsif arg.is_a?(String) then {:name => "placeholder_#{placeholders += 1}", :default => arg}
        else                         {:name => arg}
        end
      end

      # we will generate accessors to move from and to char separated values (char can be a comma, a space, etc..)
      csv_arguments = arguments.select { |arg| arg.has_key?(:csv) }

      # # #
      # Generate the class, inhereting from Struct, and generate its methods.
      # # #

      klass = Struct.new("IRC#{name}", *([:prefix] + (arguments.map { |arg| arg[:name] } + [:postfix]))) do
        @name, @to_sym, @identifier, @postfix_format = name, to_sym, identifier, postfix_format

        extend ClassMethods

        # It would be trivial to rewrite the code on factory.erb using define_methods,
        # but the code generated using eval runs about 10% faster, with the only caveat
        # *sometimes* is a little harder to follow backtraces when errors occur.
        class_eval(ERB.new(IMPLEMENTATION).result(binding), IMPLEMENTATION_PATH)

        [postfix_alias, :body, :message].compact.uniq.each do |attr|
          alias_method attr, :postfix
          alias_method "#{attr}=", :postfix=
        end
      end

      # # #
      # Evaluate any additional configuration block passed to this method, and return the resulting class.
      # # #

      klass.class_eval(&block) if block
      klass
    end

    module ClassMethods
      attr_reader :name, :to_sym, :identifier, :postfix_format

      def is_error?
        !(@name !~ /^Err[A-Z]/)
      end

      def is_reply?
        !(@name !~ /^Rpl[A-Z]/)
      end

      def is_command?
        !(@name =~ /^(Rpl|Err)[A-Z]/)
      end
    end

    require 'irc_parser/messages/commands'
    require 'irc_parser/messages/errors'
    require 'irc_parser/messages/replies'
  end
end
