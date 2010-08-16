
# line 1 "lib/irc_parser/parser.rl"

# line 38 "lib/irc_parser/parser.rl"


module IRCParser
  class Parser
    class Error < RuntimeError
      attr_accessor :source, :prefix, :identifier, :params

      def initialize(source, prefix, identifier, params)
        @source, @prefix, @identifier, @params = source, prefix, identifier, params
      end

      def to_s
        "Failed to parse #{source.inspect}"
      end
      alias_method :message, :to_s
    end

    
# line 2 "lib/irc_parser/parser.rb"
class << self
	attr_accessor :_irc_parser_trans_keys
	private :_irc_parser_trans_keys, :_irc_parser_trans_keys=
end
self._irc_parser_trans_keys = [
	0, 0, 48, 122, 48, 57, 
	48, 57, 13, 32, 10, 
	10, 1, 127, 1, 127, 
	1, 127, 1, 127, 1, 127, 
	45, 122, 32, 122, 32, 
	122, 13, 122, 32, 125, 
	1, 127, 1, 127, 45, 122, 
	32, 125, 0, 0, 0
]

class << self
	attr_accessor :_irc_parser_key_spans
	private :_irc_parser_key_spans, :_irc_parser_key_spans=
end
self._irc_parser_key_spans = [
	0, 75, 10, 10, 20, 1, 127, 127, 
	127, 127, 127, 78, 91, 91, 110, 94, 
	127, 127, 78, 94, 0
]

class << self
	attr_accessor :_irc_parser_index_offsets
	private :_irc_parser_index_offsets, :_irc_parser_index_offsets=
end
self._irc_parser_index_offsets = [
	0, 0, 76, 87, 98, 119, 121, 249, 
	377, 505, 633, 761, 840, 932, 1024, 1135, 
	1230, 1358, 1486, 1565, 1660
]

class << self
	attr_accessor :_irc_parser_indicies
	private :_irc_parser_indicies, :_irc_parser_indicies=
end
self._irc_parser_indicies = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 2, 1, 1, 1, 1, 1, 
	1, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 1, 1, 1, 1, 1, 
	1, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 1, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 1, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 1, 6, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 7, 1, 8, 
	1, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 1, 9, 9, 10, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	11, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 12, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	1, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 1, 13, 13, 14, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	15, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	1, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 1, 9, 9, 1, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	16, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 12, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	1, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 1, 17, 17, 18, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 17, 17, 17, 17, 
	1, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 1, 19, 19, 14, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	1, 20, 20, 1, 20, 20, 20, 20, 
	20, 20, 20, 20, 20, 20, 1, 1, 
	1, 1, 1, 1, 1, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 1, 
	1, 1, 1, 1, 1, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 1, 
	22, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 23, 23, 1, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 1, 1, 1, 1, 1, 1, 
	1, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 1, 1, 1, 1, 1, 
	1, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 1, 24, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 1, 1, 
	1, 1, 1, 1, 1, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 1, 
	1, 1, 1, 1, 1, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 1, 
	6, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 7, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 1, 1, 
	1, 1, 1, 1, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 1, 22, 
	26, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 27, 23, 1, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 1, 1, 1, 1, 1, 1, 28, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 29, 29, 29, 29, 1, 29, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 29, 1, 29, 1, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 1, 
	30, 30, 1, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 1, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 1, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 1, 
	30, 30, 1, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 22, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 30, 30, 1, 23, 23, 
	1, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 1, 1, 1, 1, 1, 
	1, 1, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 1, 1, 1, 1, 
	1, 1, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 1, 22, 26, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 29, 1, 1, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 1, 
	1, 1, 1, 1, 1, 28, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 1, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 1, 29, 1, 1, 0
]

class << self
	attr_accessor :_irc_parser_trans_targs
	private :_irc_parser_trans_targs, :_irc_parser_trans_targs=
end
self._irc_parser_trans_targs = [
	2, 0, 11, 14, 3, 4, 5, 6, 
	20, 7, 5, 6, 9, 7, 5, 8, 
	8, 10, 5, 10, 12, 15, 13, 12, 
	13, 14, 16, 15, 18, 19, 17
]

class << self
	attr_accessor :_irc_parser_trans_actions
	private :_irc_parser_trans_actions, :_irc_parser_trans_actions=
end
self._irc_parser_trans_actions = [
	1, 0, 0, 1, 0, 0, 2, 2, 
	0, 1, 0, 0, 0, 0, 3, 3, 
	0, 1, 4, 0, 1, 1, 5, 0, 
	0, 0, 0, 0, 0, 0, 0
]

class << self
	attr_accessor :irc_parser_start
end
self.irc_parser_start = 1;
class << self
	attr_accessor :irc_parser_first_final
end
self.irc_parser_first_final = 20;
class << self
	attr_accessor :irc_parser_error
end
self.irc_parser_error = 0;

class << self
	attr_accessor :irc_parser_en_main
end
self.irc_parser_en_main = 1;


# line 56 "lib/irc_parser/parser.rl"

    def self.run(message)
      data = message.unpack("c*") if message.is_a?(String)

      prefix = nil
      command = nil
      params = []

      
# line 2 "lib/irc_parser/parser.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = irc_parser_start
end

# line 65 "lib/irc_parser/parser.rl"
      
# line 2 "lib/irc_parser/parser.rb"
begin
	testEof = false
	_slen, _trans, _keys, _inds, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_keys = cs << 1
	_inds = _irc_parser_index_offsets[cs]
	_slen = _irc_parser_key_spans[cs]
	_trans = if (   _slen > 0 && 
			_irc_parser_trans_keys[_keys] <= data[p] && 
			data[p] <= _irc_parser_trans_keys[_keys + 1] 
		    ) then
			_irc_parser_indicies[ _inds + data[p] - _irc_parser_trans_keys[_keys] ] 
		 else 
			_irc_parser_indicies[ _inds + _slen ]
		 end
	cs = _irc_parser_trans_targs[_trans]
	if _irc_parser_trans_actions[_trans] != 0
	case _irc_parser_trans_actions[_trans]
	when 1 then
# line 25 "lib/irc_parser/parser.rl"
		begin
 mark = p 		end
	when 5 then
# line 26 "lib/irc_parser/parser.rl"
		begin
 prefix = data[mark..(p-1)] 		end
	when 2 then
# line 27 "lib/irc_parser/parser.rl"
		begin
 command = data[mark..(p-1)] 		end
	when 3 then
# line 28 "lib/irc_parser/parser.rl"
		begin
 params << data[mark..(p-1)] 		end
	when 4 then
# line 25 "lib/irc_parser/parser.rl"
		begin
 mark = p 		end
# line 28 "lib/irc_parser/parser.rl"
		begin
 params << data[mark..(p-1)] 		end
# line 2 "lib/irc_parser/parser.rb"
	end
	end
	end
	if _goto_level <= _again
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	end
	if _goto_level <= _out
		break
	end
end
	end

# line 66 "lib/irc_parser/parser.rl"

      if cs >= irc_parser_first_final
        prefix = prefix.pack("c*") if prefix
        command = command.pack("c*") if command
        params = params.map { |a| a.pack("c*") } if params
        return prefix, command, *params
      else
        raise IRCParser::Parser::Error.new(message, prefix, command, params)
      end
    end

  end
end
