# encoding: utf-8

require 'spec_helper'

describe "GET host_condition" do

  it "passes to the next route when host_name does not match" do
    app = Sinatra.new do
      host_name 'example.com'
      get '/foo' do 
        [ 201, {}, 'Hello World']
      end
    end

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'rack.input' => ''
    expect(response[0]).to be == 404

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'HTTP_HOST' => 'example.com', 'rack.input' => ''
    expect(response[0]).to be == 201
    expect(response[2]).to be == ["Hello World"]
  end
end


