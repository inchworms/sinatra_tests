# encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'

describe "get request" do
    
  context "special characters" do
    it "matches a dot ('.') as part of a named param" do
      app = Sinatra.new do
        get '/:foo/:bar' do
          [ 201, {}, "#{params[:foo]}" ]
        end
      end
      response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/user@example.com/name', 'rack.input' => ''
      expect(response[0]).to be == 201
      expect(response[2]).to be == ['user@example.com']
    end

    it "matches a literal dot ('.') outside of named params" do
      app = Sinatra.new do
        get '/:file.:ext' do
          [ 201, {}, "" ]
        end
      end

      response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/pony.jpg', 'rack.input' => ''
      expect(response[0]).to be == 201
    end

    it "literally matches dot in paths" do
      app = Sinatra.new do
        get '/test.bar' do
          [ 201, {}, "" ]
        end
      end
      response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/test.bar', 'rack.input' => ''
      expect(response[0]).to be == 201

      response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/test0bar', 'rack.input' => ''
      expect(response[0]).to be == 404
    end

    it "literally matches dollar sign in paths" do
      app = Sinatra.new do
        get '/foo$' do
          [ 201, {}, "" ]
        end
      end
      response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo$', 'rack.input' => ''
      expect(response[0]).to be == 201
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
end
