# encoding: utf-8

require 'spec_helper'

describe 'GET multiple definitions of a route' do
  it 'works with HTTP_USER_AGENT' do
    app = Sinatra.new do
      user_agent(/Mozilla/)
      get '/' do
        [ 201, {}, 'Mozilla' ]
      end
      get '/' do
        [ 201, {}, 'not Mozilla' ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'HTTP_USER_AGENT' => 'Mozilla', 'rack.input' => ''
    expect(response[2]).to be == ['Mozilla']

    response = app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => ''
    expect(response[2]).to be == ['not Mozilla']
  end
end