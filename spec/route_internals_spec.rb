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

  context "env['sinatra.route']" do
    route = nil
    let(:app) do
      Sinatra.new do
        after do
          route = request.env['sinatra.route']
        end
        get('/users/:id/status'){ "" }
      end
    end
    it "sets env['sinatra.route'] to the matched route" do
      response = get '/users/1/status'
      expect(route).to be == "GET /users/:id/status"
    end
  end

end
