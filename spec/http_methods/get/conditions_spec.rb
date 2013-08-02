# encoding: utf-8

require 'spec_helper'

describe "GET conditions" do
  context "passes to next correct route when condition calls pass explicitly" do
    let(:app) do
      Sinatra.new do
        condition do
          pass unless params[:foo] == 'bar'
        end
        get('/:foo'){ 'Hello World' }
      end
    end

    context "get '/bar'" do
      let(:response){ get '/bar' }
      it("status 200"){ expect(response.status).to be == 200 }
      it("body Hello World"){ expect(response.body).to be == 'Hello World'}
    end

    context "get '/foo'" do
      let(:response){ get '/foo' }
      it("status 404"){ expect(response.status).to be == 404}
    end
  end

  it "passes when matching condition returns false" do
    app = Sinatra.new do
      condition do 
        params[:foo] == 'bar'
      end
      get '/:foo' do
        [201, {}, 'Hello World']
      end
    end

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/bar', 'rack.input' => ''
    expect(response[0]).to be == 201
    expect(response[2]).to be == ['Hello World']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'rack.input' => ''
    expect(response[0]).to be == 404
  end

  it "does not pass when matching condition returns nil" do
    app = Sinatra.new do
      condition do
        nil
      end
      get '/:foo' do
        [201, {}, 'Hello World']
      end
    end

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/bar', 'rack.input' => ''
    expect(response[0]).to be == 201
    expect(response[2]).to be == ['Hello World']
  end

  it 'allows custom route-conditions to be set via route options' do
    protector = Module.new do
      def protect(*args)
        condition do
          unless authorize(params["user"], params["password"])
            halt 403, "go away"
          end
        end
      end
    end

    app = Sinatra.new do
      register protector

      helpers do
        def authorize(username, password)
          username == "foo" && password == "bar"
        end
      end

      get "/", :protect => true do
        "hey"
      end
    end

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'rack.input' => ''
    expect(response[0]).to be == 403
    expect(response[2]).to be == ["go away"]

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'QUERY_STRING' => 'user=foo&password=bar', 'rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[2]).to be == ["hey"]
  end
end
