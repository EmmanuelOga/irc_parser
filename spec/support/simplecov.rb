require 'simplecov'

SimpleCov.adapters.define 'rspec' do
  add_filter '/spec/'

  # network / protocol stuff is tested with cucumber
  add_filter 'connection'
  add_filter 'listener'
  add_filter "protocol"
end

SimpleCov.start 'rspec'
