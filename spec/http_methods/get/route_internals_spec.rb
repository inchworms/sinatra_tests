# encoding: utf-8

require 'spec_helper'

describe "GET route internals" do

  it "returns the route signature" do

    signature = list = nil

    app = Sinatra.new do
      signature = post('/') { }
      list = routes['POST']
    end

    expect(signature).to be_kind_of(Array)
    expect(signature.length).to be == 4
    expect(list).to include(signature)
  end




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
