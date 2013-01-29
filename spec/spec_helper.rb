require 'rubygems'
require 'bundler/setup'

require 'mongoid'
require 'mongoid/mongoid_retry'
require 'database_cleaner'

require 'rspec'

Mongoid.configure do |config|
  if Mongoid::VERSION >= "3"
    config.connect_to('mongoid_retry_test')
  else
    config.master = Mongo::Connection.new.db('mongoid_retry_test')
    config.allow_dynamic_fields = false
  end
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.after :each do
    DatabaseCleaner.clean
  end
end
