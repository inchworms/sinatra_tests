# encoding: utf-8

require 'spec_helper'

describe "GET special characters" do
  context "matches a dot ('.') as part of a named param" do
    let(:app) do
      Sinatra.new do
        get('/:mail/:name'){ "mail = #{params[:mail]}; name = #{params[:name]}" }
      end
    end
    it "handles request: /user@example.com/user with route: /:mail/:name" do
      response = get '/user@example.com/user'
      expect(response.body).to be == "mail = user@example.com; name = user"
    end
  end

  context "matches a literal dot ('.') outside of named params" do
    let(:app) do
      Sinatra.new do
        get '/:file.:ext' do
          pony = params[:file]
          jpg = params[:ext]
        end
      end
    end
    it "handles request: /pony.jpg with route: /:file.:ext" do
      response = get '/pony.jpg'
      expect(response.status).to be == 200
    end
  end

  context "literally matches dot in paths" do
    let(:app) do
      Sinatra.new do
        get('/test.bar'){}
      end
    end
    it "handles request: /test.bar with route: /test.bar" do
      response = get '/test.bar'
      expect(response.status).to be == 200
    end

    it "does not handle request: /test0bar with route: /test.bar" do
      response = get '/test0bar'
      expect(response.status).to be == 404
    end
  end

  context "literally matches dollar sign in paths" do
    let(:app) do
      Sinatra.new do
        get('/foo$'){}
      end
    end
    it "handles request: /foo$ with route: /foo$" do
      response = get '/foo$'
      expect(response.status).to be == 200
    end
    
    it "does not handle request: /foo with route: /foo$" do
      response = get '/foo'
      expect(response.status).to be == 404
    end
  end

  it "literally matches plus sign in paths" do
    app = Sinatra.new do
      get '/fo+o' do
        [ 201, {}, "" ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/fo%2Bo', 'rack.input' => ''
    expect(response[0]).to be == 201

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foooooooo', 'rack.input' => ''
    expect(response[0]).to be == 404
  end

  it "does not convert plus sign into space as the value of a named param" do
    app = Sinatra.new do
      get '/:foo' do
        [ 201, {}, "#{params[:foo]}" ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/baz+bar', 'rack.input' => ''
    expect(response[2]).to be == ["baz+bar"]
  end

  it "literally matches parenthese in paths" do
    app = Sinatra.new do
      get '/foo(bar)' do
        [ 201, {}, "" ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo(bar)', 'rack.input' => ''
    expect(response[0]).to be == 201
  end

  it "matches paths that include spaces encoded with %20 or +" do
    app = Sinatra.new do
      get '/path with spaces' do
        [ 201, {}, "" ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/path%20with%20spaces', 'rack.input' => ''
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/path+with+spaces', 'rack.input' => ''
    expect(response[0]).to be == 201
  end

  it "matches paths that include ampersands" do
    app = Sinatra.new do
      get '/:foo' do
        [ 201, {}, "#{params[:foo]}" ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/bar&baz', 'rack.input' => ''
    expect(response[2]).to be == ['bar&baz']
  end
end
