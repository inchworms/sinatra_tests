# 'encoding: utf-8

require 'spec_helper'

describe 'GET route flow' do

  it 'returns response immediately on halt'
  it 'halts with a response tuple'
  it 'halts with an array of strings'

  it 'sets response.status with halt' do
    status_was = nil
    app = Sinatra.new do
      after { status_was = status }
      get('/') { halt 500, 'error' }
    end
    
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'rack.input' => ''
    expect(response[0]).to be == 500
    expect(status_was).to be == 500
       
  end
  

  it 'transitions to the next matching route on pass' do

    verifier = Proc.new { |request|
        expect(request.params).not_to include('foo') 
      }

    app = Sinatra.new do 
      get '/:foo' do
        pass
          'Hello Foo'
      end

      get '/*' do
         verifier.call(request)
        'Hello World'
      end
    end
  
  response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/bar', 'rack.input' => ''
  expect(response[2]).to be == ['Hello World']

  end
  

  context 'no subsequent route matches' do
    let(:app) do
      Sinatra.new do 
        get ('/:foo') do
          pass
        end
      end
    end
   
    let(:response) { get '/bar' }
   
    it('transitions to 404 when passed') do
      expect(response.status).to be(404)
    end
    
    it('sets X-Cascade header when passed') do
      expect(response.headers['X-Cascade']).to eq('pass')
    end
  end

  
  context 'optional blocks' do
    let(:app) do
      Sinatra.new do
        get('/') do
          pass do
            'this'
          end
          'not this'
        end
      end
    end
    

    it 'uses optional block passed to pass as route block if no other route is found' do 
      expect(get('/').body).to be == "this"
    end
  end


  it "matches routes defined in superclasses" do
    base = Class.new(Sinatra::Base)
    base.get('/foo') { 'foo in baseclass' }

    app = Sinatra.new(base) {
      get('/bar') { 'bar in subclass' }
    }

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'rack.input' => ''
    expect(response[2]).to be == ['foo in baseclass']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/bar', 'rack.input' => ''
    expect(response[2]).to be == ['bar in subclass'] 

  end
  

  it 'matches routes in subclasses instead of superclasses' do
    base = Class.new(Sinatra::Base)
    base.get('/foo') { 'foo in baseclass' }
    base.get('/bar') { 'bar in baseclass' }

    app = Sinatra.new(base) do 
      get'/foo' do 
        'foo in subclass'
      end
    end

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'rack.input' => ''
    expect(response[2]).to be == ['foo in subclass']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/bar', 'rack.input' => ''
    expect(response[2]).to be == ['bar in baseclass'] 
  end

  context 'internal request' do
    let(:app) do
      Sinatra.new do
        get('/foo') do
          status, headers, body = call env.merge("PATH_INFO" => '/bar')
          [201, headers, body.each.map(&:upcase)]
        end

        get('/bar') do
          'bar'
        end
      end
    end

    it 'allows using call to fire another request internally' do 
      expect(get('/foo').status).to be == 201
      expect(get('/foo').body).to be == "BAR"
    end

  end


  context 'routing middleware' do
    middleware = Sinatra.new
    inner_app  = Sinatra.new { get('/foo') { 'hello' } }

    builder = Rack::Builder.new do
      use middleware 
      map('/test') do 
        run inner_app
      end     
    end

    let(:app) do
      builder.to_app
    end

    it 'plays well with other routing middleware' do
      expect(get('/test/foo').body).to be == 'hello'
      expect(get('/test/foo').status).to be == 200
    end
  end

end