# encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'


describe "http methods" do 

  # these tests should include
  # get, post, delete, head, put, options (all part of rfc2616)
  # patch
  # link, unlink

  describe "get" do

    context "/" do
      let(:app) do
        Sinatra.new do
          get('/') { [201, { 'Header' => 'foo' }, ["a", "b", "c"]] }
        end
      end
      let(:response) { get '/' }
      # does the same as:
      # let(:response) { @app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => '' }

      it("returns 201 as a status") { expect(response.status).to be == 201 }
      it("returns the complete body as string") { expect(response.body).to be == 'abc' }
      it("sets a header as foo") { expect(response.header['Header']).to be == 'foo' }
    end

    it "/hello routes gets hello route" do
      app = Sinatra.new do
        get '/hello' do
          [201, {}, '']
        end
      end
      response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello', 'rack.input' => ''
      expect(response[0]).to be == 201
    end

    context "returning an IO-like object" do
      let(:app) do
        Sinatra.new do
          get '/' do
            StringIO.new("Hello World")
          end
        end
      end
      let(:response) { get '/' }

      it("returns 200 as Status") { expect(response.status).to be == 200 } #TODO? specify 201?
      it("returns the object's body") { expect(response.body).to eq "Hello World" }
    end

    it "returns empty array when body is nil" do
      app = Sinatra.new do
        get '/' do
          [201, {}, nil]
        end
      end
      response = app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => ''
      expect(response[2]).to be == []
    end

    it "supports params like /hello/:name" do
      app = Sinatra.new do
        get '/Hello/:name' do
          [201, {}, ["Hello #{params[:name]}!"]]
        end
      end
      response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/Hello/Horst', 'rack.input' => ''
      expect(response[2]).to be == ["Hello Horst!"]
    end

    context "missing routes" do
      let(:app) { Sinatra.new }
      let(:response) { get '/noroute' }

      it("sets X-Cascade header when no route satisfies the request") { expect(response.header['X-Cascade']).to be == 'pass' }
      it("throws an 404") { expect(response.status).to be == 404 }

      it "does not set X-Cascade header when x_cascade has been disabled" do
        app.disable :x_cascade
        expect(response.header).to_not include("X-Cascade")
      end
    end

    context "404" do
      let(:app) {Sinatra.new}
      let(:response) { get '/' }

      it "recalculates body length correctly for 404 response" do
        expect(response.body.length).to be == (response.header['Content-Length']).to_i #DOTO Why
      end
    end

    context "unicode" do
      let(:app) do
        Sinatra.new do
          get '/f%C3%B6%C3%B6' do
            [201, {}, ""]
          end
        end
      end
      let(:response) { get '/f%C3%B6%C3%B6' }

      it "allows using unicode" do
        expect(response.status).to be == 201
      end

      let(:app) do
        Sinatra.new do
          get '/föö' do
            [201, {}, ""]
          end
        end
      end
      let(:response) { get '/f%C3%B6%C3%B6' }

      it "allows using another type of unicode" do
        expect(response.status).to be == 201
      end

      it "handles encoded slashes correctly" do
        app = Sinatra.new do
          get '/:a' do
            [201, {}, "#{params[:a]}"] 
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

    context "PATH_INFO"
      it 'matches empty PATH_INFO to "/" if no route is defined for ""' do
        app = Sinatra.new do
          get '/' do
            [201, {}, '']
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '', 'rack.input' => ''
        expect(response[0]).to be == 201
      end

  end
end


