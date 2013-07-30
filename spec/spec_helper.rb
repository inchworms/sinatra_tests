ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'sinatra'
require 'rspec'


RSpec.configure do |conf|
	conf.include Rack::Test::Methods
end

class RegexpLookAlike
  class MatchData
    def captures
      ["this", "is", "a", "test"]
    end
  end

  def match(string)
    ::RegexpLookAlike::MatchData.new if string == "/this/is/a/test/"
  end

  def keys
    ["one", "two", "three", "four"]
  end
end