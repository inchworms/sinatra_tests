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
        get('/test.bar'){'working'}
      end
    end
    it "handles request: /test.bar with route: /test.bar" do
      response = get '/test.bar'
      expect(response.body).to be == 'working'
    end

    it "does not handle request: /test0bar with route: /test.bar" do
      response = get '/test0bar'
      expect(response.status).to be == 404
    end
  end

  context "literally matches dollar sign in paths" do
    let(:app) do
      Sinatra.new do
        get('/foo$'){'working'}
      end
    end
    it "handles request: /foo$ with route: /foo$" do
      response = get '/foo$'
      expect(response.body).to be == 'working'
    end

    it "does not handle request: /foo with route: /foo$" do
      response = get '/foo'
      expect(response.status).to be == 404
    end
  end

  context "literally matches plus sign in paths" do
    let(:app) do
      Sinatra.new do
        get('/fo+o'){'working'}
      end
    end

    it "handles request: /fo%2Bo with route: /fo+o" do
      response = get '/fo%2Bo'
      expect(response.body).to be == 'working'
    end

    it "handles request: /fo+o with route: /fo+o" do
      response = get '/fo+o'
      expect(response.body).to be == 'working'
    end

    it "does not handle request: /foo with route: /fo+o" do
      response = get '/foo'
      expect(response.status).to be == 404
    end
  end

  context "does not convert plus sign into space as the value of a named param" do
    let(:app) do
      Sinatra.new do
        get('/:foo'){ "#{params[:foo]}" }
      end
    end
    it "handles request: /baz+bar with route: /:foo" do
      response = get '/baz+bar'
      expect(response.body).to be == "baz+bar"
    end
  end

  context "literally matches parenthese in paths" do
    let(:app) do
      Sinatra.new do
        get('/foo(bar)'){'working'}
      end
    end
    it "handles request: /foo(bar) with route: /foo(bar)" do
      response = get '/foo(bar)'
      expect(response.body).to be == 'working'
    end
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

