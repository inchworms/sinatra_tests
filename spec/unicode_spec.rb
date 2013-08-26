# encoding: utf-8

require 'spec_helper'

describe "GET handles unicode" do
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

      it "handles the route #{unicode_route}" do
        expect(response.status).to be == 201
      end
    end
  end

  context "encoded slashes" do
    let(:app) do
      Sinatra.new do
        get '/:a' do
          "#{params[:a]}"
        end
      end
    end
    let(:response){ get '/foo%2Fbar' }
    it "handles encoded slashes /foo%2Fbar correctly" do
      expect(response.body).to be == "foo/bar"
    end
  end

  context "error handlers" do
    let(:app) do
      Sinatra.new do
        get '/' do
          [201, { 'Content-Type' => 'text/plain'}, '']
        end
      end
    end
    let(:response) { get '/nonexistingroute' }

    context "the /nonexistingroute" do 
      it"returns a 404" do
        expect(response.status).to be == 404
      end

      it "sets content-type to text/html;charset=utf-8" do
        expect(response.header["Content-Type"]).to be == "text/html;charset=utf-8"
      end
    end
  end
end
