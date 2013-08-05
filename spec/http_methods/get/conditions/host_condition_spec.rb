# encoding: utf-8

require 'spec_helper'

describe "GET host_condition" do

  context "passes to the next route when host_name does not match" do
    let(:app) do
      Sinatra.new do
        host_name 'example.com'
        get('/foo'){ 'Hello World' }
      end
    end

    context "/foo" do
      let(:response){ get '/foo' }
      it("returns status"){ expect(response.status).to be == 404 }
    end

    context "/foo HTTP_HOST = example.com" do
      let(:response){ get '/foo', {}, {'HTTP_HOST' => 'example.com'} }
      it("returns correct body"){ expect(response.body).to be == "Hello World" }
    end
  end
end


