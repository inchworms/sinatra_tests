# encoding: utf-8

require 'spec_helper'

describe "GET route internals" do

  it "returns the route signature"

  it "sets env['sinatra.route'] to the matched route" do

    verifier = Proc.new { |request|
        expect(request.env['sinatra.route']).to be == "GET /users/:id/status"   
      }

    app = Sinatra.new do 
      after do 
        verifier.call(request)
      end
      get '/users/:id/status' do
        [201, {} ["ok"]]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/users/1/status', 'rack.input' => ''
    expect(response[0]).to be == 201
  end
  
end



 
 