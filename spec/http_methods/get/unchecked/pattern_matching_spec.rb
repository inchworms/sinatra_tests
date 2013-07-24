# encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'

describe "GET pattern matching" do
  it 'makes regular expression captures available in params[:captures]'
  it 'supports regular expression look-alike routes'
  it 'raises a TypeError when pattern is not a String or Regexp'

  it "supports named captures like %r{/hello/(?<person>[^/?#]+)}" do
    app = Sinatra.new do
      get Regexp.new('/hello/(?<person>[^/?#]+)') do
        [ 201, {}, ["Hello #{params['person']}"] ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello/Frank', 'rack.input' => ''
    expect(response[2]).to be == ["Hello Frank"]
  end

  it "supports optional named captures like %r{/page(?<format>.[^/?#]+)?}" do
    app = Sinatra.new do
      get Regexp.new('/page(?<format>.[^/?#]+)?') do
        [ 201, {}, ["format=#{params[:format]}"] ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/page.html', 'rack.input' => ''
    expect(response[2]).to be == ["format=.html"]

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/page.xml', 'rack.input' => ''
    expect(response[2]).to be == ["format=.xml"]

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/page', 'rack.input' => ''
    expect(response[2]).to be == ["format="]
  end

  context 'does not concatenate params with the same name' do
    let(:app) do
      Sinatra.new do
        get('/:foo') {[ 201, {}, [params[:foo]] ]}
      end
    end
    let(:response){ get '/a?foo=b' }
    it("will take the first param only") { expect(response.body).to be == 'a'}
  end

  it "supports single splat params like /*" do
    app = Sinatra.new do
      get '/*' do
        [ 201, {}, "#{params["splat"].join}" ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'rack.input' => ''
    expect(response[2]).to be == ["foo"]

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo/bar/baz', 'rack.input' => ''
    expect(response[2]).to be == ["foo/bar/baz"]
  end

  it "supports mixing multiple splat params like /*/foo/*/*" do
    app = Sinatra.new do
      get '/*/foo/*/*' do
        [ 201, {}, "#{params["splat"].join(" ")}" ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/bar/foo/bling/baz/boom', 'rack.input' => ''
    expect(response[2]).to be == ["bar bling baz/boom"]

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/bar/foo/baz', 'rack.input' => ''
    expect(response[0]).to be == 404
  end

  it "supports mixing named and splat params like /:foo/*" do
    app = Sinatra.new do
      get '/:foo/*' do
        [ 201, {}, "" ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo/bar/baz', 'rack.input' => ''
    expect(response[0]).to be == 201
  end

  context "nested params" do
    let(:app) do
      Sinatra.new do
        get ('/hello') { [201, {}, "#{params["person"]["name"]}"] }
      end
    end
    let(:response){ get '/hello?person[name]=John+Doe' }
    it("supports basic nested params") { expect(response.body).to be == "John Doe" }
  end

  it "URL decodes named parameters and splats" do
    app = Sinatra.new do
      get '/:foo/*' do
        [ 201, {}, "#{params[:foo]};#{params[:splat]}" ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello%20world/how%20are%20you', 'rack.input' => ''
    expect(response[0]).to be == 201
    expect(response[2]).to be == ["hello world;[\"how are you\"]"]
  end

  it 'supports regular expressions' do
    app = Sinatra.new do
      get Regexp.new('^\/foo...\/bar$') do
        [ 201, {}, "" ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foooom/bar', 'rack.input' => ''
    expect(response[0]).to be == 201
  end
end

