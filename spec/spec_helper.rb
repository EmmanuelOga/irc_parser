$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'irc_parser'

require 'ap'
require 'rspec'
require 'support/messages_helper.rb'

RSpec.configure do |c|
  c.extend ParsingHelper
end
