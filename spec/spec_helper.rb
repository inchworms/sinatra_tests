ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'sinatra'
require 'rspec'


RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

