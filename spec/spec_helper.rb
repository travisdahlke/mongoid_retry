require 'rubygems'
require 'bundler/setup'

require 'mongoid'
require 'mongoid/mongoid_retry'

require 'rspec'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('mongoid_retry_test')
  config.allow_dynamic_fields = false
  config.persist_in_safe_mode = true
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.after :each do
    Mongoid.master.collections.reject { |c| c.name =~ /^system\./ }.each(&:remove)
  end
end
