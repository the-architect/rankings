require 'simplecov'
require 'simplecov-html'

SimpleCov.start do
  add_filter '/spec'
  add_filter '/vendor'
  add_filter '/bin'
  add_filter '/pkg'
end

require 'bundler'
Bundler.setup


require 'rspec'
require 'fakeredis/rspec'

RSpec.configure do |config|
  config.mock_with :mocha
  #config.fail_fast = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run_excluding :wip => true
end


