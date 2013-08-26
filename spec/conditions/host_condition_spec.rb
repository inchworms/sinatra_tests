# encoding: utf-8

require 'spec_helper'

describe "GET host condition" do
  context "passes to the next route when host_name does not match" do
    let(:app) do
      Sinatra.new do
        host_name 'example.com'
        get('/foo'){ }
      end
    end

    it "get /foo returns 404" do
      response = get '/foo'
      expect(response.status).to be == 404
    end

    it "get /foo & HTTP_HOST = example.com returns 200" do
      response = get '/foo', {}, {'HTTP_HOST' => 'example.com'}
      expect(response.status).to be == 200
    end
  end

   context 'adds hostname condition when hostname is in options' do
    let(:app) do
      Sinatra.new do 
        get('/foo', :host => 'example.com'){}
      end
    end

    it "get /foo returns 404" do
      response = get '/foo'
      expect(response.status).to be == 404
    end

    it "get /foo & HTTP_HOST = example.com returns 200" do
      response = get '/foo', {}, {'HTTP_HOST' => 'example.com'}
      expect(response.status).to be == 200
    end
  end

end

