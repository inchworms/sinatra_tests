# encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'

describe "get request" do

	context "host_condition" do 
 
		it "passes to the next route when host_name does not match" do
			app = Sinatra.new do
				host_name 'example.com'
	      get '/foo' do 
	        'Hello World'
	      end
	    end

	    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'rack.input' => ''
	    expect(response[0]).to be == 404

	    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'HTTP_HOST' => 'example.com', 'rack.input' => ''
	    expect(response[0]).to be == 200
	    expect(response[2]).to be == ["Hello World"]
	  end
	end
end
	
	#old test	
  #   mock_app {
  #     host_name 'example.com'
  #     get '/foo' do
  #       'Hello World'
  #     end
  #   }
  #   get '/foo'
  #   assert not_found?

  #   get '/foo', {}, { 'HTTP_HOST' => 'example.com' }
  #   assert_equal 200, status
  #   assert_equal 'Hello World', body
  



