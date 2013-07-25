# encoding: utf-8

require 'spec_helper'

describe 'GET agent conditions' do

	it 'passes to the next route when user_agent does not match' do
		app = Sinatra.new do
			user_agent(/Foo/)
			get '/foo' do
				[201, {}, "Hello World"]
			end
		end

		response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'rack.input' => ''
		expect(response[0]).to be == 404

		response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'HTTP_USER_AGENT' => 'Foo Bar', 'rack.input' => ''
		expect(response[0]).to be == 201
		expect(response[2]).to be == ["Hello World"]
  end


	it 'treats missing user agent like an empty string' do
		app = Sinatra.new do
			user_agent(/.*/)
			get '/' do
				[201, {},"Hello World"]
			end
		end

		response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'rack.input' => ''
		expect(response[0]).to be == 201
		expect(response[2]).to be == ["Hello World"]
  end
	

	it 'makes captures in user agent pattern available in params[:agent]' do
		app = Sinatra.new do
			user_agent(/Foo (.*)/)
			get '/foo' do
				'Hello ' + params[:agent].first
			end
		end

		response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'HTTP_USER_AGENT' => 'Foo Bar', 'rack.input' => ''
		expect(response[0]).to be == 200
		expect(response[2]).to be == ["Hello Bar"]
	end

	it 'adds hostname condition when it is in options' do
		app = Sinatra.new do 
			get '/foo', :host => 'host' do 
				'foo'
			end
		end

		response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'rack.input' => ''
		expect(response[0]).to be == 404
	end


end
