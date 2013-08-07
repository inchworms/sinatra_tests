# encoding: utf-8

require 'spec_helper'

describe 'GET multiple definitions of a route' do
  let(:app) do
    Sinatra.new do
      user_agent(/Mozilla/)
      get('/'){ 'Mozilla' }

      get('/'){ 'not Mozilla' }
    end
  end
  it 'setting a HTTP_USER_AGENT' do
    response = get '/', {}, {'HTTP_USER_AGENT' => 'Mozilla'}
    expect(response.body).to be == 'Mozilla'
  end
  it 'setting no HTTP_USER_AGENT' do
    response = get '/'
    expect(response.body).to be == 'not Mozilla'
  end
end