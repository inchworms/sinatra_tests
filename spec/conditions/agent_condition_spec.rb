# encoding: utf-8

require 'spec_helper'

describe 'GET agent conditions' do

  context 'passes to the next route when user_agent does not match' do
    let(:app) do
      Sinatra.new do
        user_agent(/Foo/)
        get('/foo'){ "Hello World" }
      end
    end

    it "get /foo returns a 404" do
     response = get '/foo'
     expect(response.status).to be == 404
    end

    it "get /foo & HTTP_USER_AGENT = Foo Bar returns correct body" do
     response = get '/foo', {}, {'HTTP_USER_AGENT' => 'Foo Bar'}
     expect(response.body).to be == "Hello World"
    end
  end

  context 'treats missing user agent like an empty string' do
    let(:app) do
      Sinatra.new do
        user_agent(/.*/)
        get('/'){ "Hello World" }
      end
    end

    it "get / returns correct body" do
      response = get '/'
      expect(response.body).to be == "Hello World"
    end
  end

  context 'makes captures in user agent pattern available in params[:agent]' do
    let(:app) do
      Sinatra.new do
        user_agent(/Baz (.*)/)
        get('/foo'){'Hello ' + params[:agent].first}
     end
   end

   it "get /foo & HTTP_USER_AGENT = Foo Bar returns correct body" do
     response = get '/foo', {}, {'HTTP_USER_AGENT' => 'Baz World'}
     expect(response.body).to be == "Hello World"
   end
  end

end
