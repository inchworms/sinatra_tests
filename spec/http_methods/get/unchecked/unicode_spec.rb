# encoding: utf-8

require 'spec_helper'

describe "GET unicode" do
  {'percent encoded' => '/f%C3%B6%C3%B6', 'utf-8 literal' => '/föö'}.each do |kind, unicode_route|
    context kind do
      let(:app) do
        Sinatra.new do
          get unicode_route do
            [ 201, {}, "" ]
          end
        end
      end
      let(:response) { get '/f%C3%B6%C3%B6' }

      it "handles the route" do
        expect(response.status).to be == 201
      end
    end
  end

  it "handles encoded slashes correctly" do
    app = Sinatra.new do
      get '/:a' do
        [ 201, {}, "#{params[:a]}" ] 
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo%2Fbar', 'rack.input' => ''
    expect(response[2]).to be == ["foo/bar"]
  end

  it "overrides the content-type in error handlers" do
    app = Sinatra.new do
      get '/' do
        [201, { 'Content-Type' => 'text/plain'}, '']
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/nonexistingroute', 'rack.input' => ''
    expect(response[0]).to be == 404
    expect(response[1]["Content-Type"]).to be == "text/html;charset=utf-8"
  end
end
