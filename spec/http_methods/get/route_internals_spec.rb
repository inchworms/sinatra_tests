# encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'

describe "GET route internals" do

	it 'returns the route signature'

  it "sets env['sinatra.route'] to the matched route" do
  	app = Sinatra.new do 
  		after do 
  			expect(response[1][env]).to be == ["sinatra.route"]
  		end
  		get '/users/:id/status' do
  			'ok'
  		end
  	end
  	response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/users/1/status', 'rack.input' => ''
   end

end


 