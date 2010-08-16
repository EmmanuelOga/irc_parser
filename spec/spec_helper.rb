$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'irc_parser'
require 'irc_parser/messages'

require 'ap'
require 'spec'
require 'spec/autorun'
require 'spec/support/messages_helper.rb'

Spec::Runner.configure do |config|
  config.extend ParsingHelper
end
