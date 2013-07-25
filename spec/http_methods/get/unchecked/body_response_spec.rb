# encoding: utf-8

require 'spec_helper'

describe " GET body responses" do
  it "returns empty array when body is nil" do
    app = Sinatra.new do
      get '/' do
        [ 201, {}, nil ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => ''
    expect(response[2]).to be == []
  end
end
