# encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'

describe "get request" do

	context "PATH_INFO" do
		it 'matches empty PATH_INFO to "/" if no route is defined for ""' do
		  app = Sinatra.new do
		    get '/' do
		      [ 201, {}, '' ]
		    end
		  end
		  response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '', 'rack.input' => ''
		  expect(response[0]).to be == 201
		end

		it 'matches empty PATH_INFO to "" if a route is defined for ""' do
		  app = Sinatra.new do
		    get '/' do
		      [ 201, {}, 'not working' ]
		    end
		    get '' do
		      [ 201, {}, 'working' ]
		    end
		  end
		  response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '', 'rack.input' => ''
		  expect(response[2]).to be == ['working']
		end
	end
end
