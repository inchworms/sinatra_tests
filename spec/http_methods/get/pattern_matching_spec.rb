# encoding: utf-8

require 'spec_helper'

describe "GET pattern matching" do
  the_params = nil

    let(:app) do 
      Sinatra.new {
        get(/^\/fo(.*)\/ba(.*)/) do
          the_params = params.dup
        end
      }
    end
  

  it 'makes regular expression captures available in params[:captures]' do
    get '/foorooomma/baf'

    expect(the_params[:captures]).to be == ['orooomma', 'f']
  end

  it 'supports regular expression look-alike routes' do
    class RegexpLookAlike
      class MatchData
        def captures
          ["this", "is", "a", "test"]
        end
      end

      def match(string)
        ::RegexpLookAlike::MatchData.new if string == "/this/is/a/test/"
      end

      def keys
        ["one", "two", "three", "four"]
      end
    end

    verifier = Proc.new { |params|
        expect(params[:one]).to be == 'this'
        expect(params[:two]).to be == 'is'
        expect(params[:three]).to be == 'a'
        expect(params[:four]).to be == 'test'
      }

    app = Sinatra.new do
      get(RegexpLookAlike.new) do
        verifier.call(params)
        [201, {},'right on']
      end
    end

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/this/is/a/test/', 'rack.input' => ''
    expect(response[2]).to be == ["right on"]

  end

  it 'raises a TypeError when pattern is not a String or Regexp' do
    expect { Sinatra.new { get(42){} } }.to raise_error(TypeError)
  end

  context "supports named captures like %r{/hello/(?<person>[^/?#]+)}" do
    let(:app) do
      Sinatra.new do
        get(Regexp.new('/hello/(?<person>[^/?#]+)')){"Hello #{params['person']}" }
      end
    end
    it "handles request: /hello/Frank with route: /hello/(?<person>[^/?#]+)" do
      response = get '/hello/Frank'
      expect(response.body).to be == "Hello Frank"
    end
  end

  context "supports optional named captures like %r{/page(?<format>.[^/?#]+)?}" do
    let(:app)do
      Sinatra.new do
        get(Regexp.new('/page(?<format>.[^/?#]+)?')){ "format=#{params[:format]}" }
      end
    end
    context "request: /page.html" do
      let(:response){ get '/page.html' }
      it("returns format=html"){ expect(response.body).to be == "format=.html" }
    end
    context "request: /page.xml" do
      let(:response){ get '/page.xml' }
      it(" returns format=xml"){ expect(response.body).to be == "format=.xml" }
    end
    context "request: /page" do
      let(:response){ get '/page' }
      it("returns no format"){ expect(response.body).to be == "format=" }
    end
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

  context "supports single splat params like /*" do
    let(:app) do
      Sinatra.new do
        get('/*'){ "#{params["splat"].join}" }
      end
    end
    it "handles request: /foo with route: /*" do
      response = get '/foo'
      expect(response.body).to be == "foo"
    end

    it "handles request: /foo/bar/baz with route: /*" do
      response = get '/foo/bar/baz'
      expect(response.body).to be == "foo/bar/baz"
    end
  end

  context "supports mixing multiple splat params like /*/foo/*/*" do
    let(:app) do
      Sinatra.new do
        get('/*/foo/*/*'){ "#{params["splat"].join(" ")}" }
      end
    end
    it "handles request: /bar/foo/bling/baz/boom with route: /*/foo/*/*" do
      response = get '/bar/foo/bling/baz/boom'
      expect(response.body).to be == "bar bling baz/boom"
    end

    it "does not handle request: /bar/foo/baz with route: /*/foo/*/*" do
      response = get '/bar/foo/baz'
      expect(response.status).to be == 404
    end
  end

  context "supports mixing named and splat params like /:foo/*" do
    let(:app) do
      Sinatra.new do
        get('/:foo/*'){ 'working' }
      end
    end
    it "handles request: /foo/bar/baz with route: /:foo/*" do
      response = get '/foo/bar/baz'
      expect(response.body).to be == 'working'
    end
  end

  context "nested params" do
    let(:app) do
      Sinatra.new do
        get ('/hello'){ "#{params["person"]["name"]}" }
      end
    end
    let(:response){ get '/hello?person[name]=John+Doe' }
    it("supports basic nested params") { expect(response.body).to be == "John Doe" }
  end

  context "URL decodes named parameters and splats" do
    let(:app) do
      Sinatra.new do
      get('/:foo/*'){ "#{params[:foo]};#{params[:splat]}" }
      end
    end
    it "handles request: /hello%20world/how%20are%20you with route: /:foo/*" do
      response = get '/hello%20world/how%20are%20you'
      expect(response.body).to be == "hello world;[\"how are you\"]"
    end
  end

  context 'supports regular expressions' do
    let(:app) do
      Sinatra.new do
        get(Regexp.new('^\/foo...\/bar$')){ "working" }
      end
    end
    it "handles request: /foooom/bar with route: Regexp.new('^\/foo...\/bar$')" do
      response = get '/foooom/bar'
      expect(response.body).to be == 'working'
    end
  end
end

