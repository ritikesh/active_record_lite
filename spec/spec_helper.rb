require "rails"
require "active_record"
require "sqlite3"
require "active_record_lite"

shared_context "use connection", use_connection: true do
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

    ActiveRecordLite::Railtie.initializers.each(&:run)
    
    load File.dirname(__FILE__) + '/schema.rb'
    require File.dirname(__FILE__) + '/models.rb'
end


RSpec.configure do |config|
    config.mock_with :rspec
end