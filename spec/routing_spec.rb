# encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'


describe "http methods" do 

  # these tests should include
  # get, post, delete, head, put, options (all part of rfc2616)
  # patch
  # link, unlink

  describe "get requests" do

    context "basic '/' route" do
    
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
    
      it "/hello routes gets hello route" do
        app = Sinatra.new do
          get '/hello' do
            [201, {}, '']
          end
        end
        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello', 'rack.input' => ''
        expect(response[0]).to be == 201
      end

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

      it("returns 200 as Status") { expect(response.status).to be == 200 }
      it("returns the object's body") { expect(response.body).to eq "Hello World" }
    end

    context "body responses" do
      it "returns empty array when body is nil" do
        app = Sinatra.new do
          get '/' do
            [201, {}, nil]
          end
        end
        response = app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => ''
        expect(response[2]).to be == []
      end
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
        expect(response.body.length).to be == (response.header['Content-Length']).to_i
      end
    end

    context "unicode in routes" do
      {'percent encoded' => '/f%C3%B6%C3%B6', 'utf-8 literal' => '/föö'}.each do |kind, unicode_route|
        context kind do
          let(:app) do
            Sinatra.new do
              get unicode_route do
                [201, {}, ""]
              end
            end
          end
          let(:response) { get '/f%C3%B6%C3%B6' }

          it "handles the route" do
            expect(response.status).to be == 201
          end
        end
      end
    end

    context "percent escaping" do
      it "handles encoded slashes correctly" do
        app = Sinatra.new do
          get '/:a' do
            [201, {}, "#{params[:a]}"] 
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo%2Fbar', 'rack.input' => ''
        expect(response[2]).to be == ["foo/bar"]
      end
    end

    context "error handlers" do
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

    context "empty PATH_INFO" do
      it 'matches empty PATH_INFO to "/" if no route is defined for ""' do
        app = Sinatra.new do
          get '/' do
            [201, {}, '']
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '', 'rack.input' => ''
        expect(response[0]).to be == 201
      end

      it 'matches empty PATH_INFO to "" if a route is defined for ""' do
        app = Sinatra.new do
          get '/' do
            [201, {}, 'not working']
          end
          get '' do
            [201, {}, 'working']
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '', 'rack.input' => ''
        expect(response[2]).to be == ['working']
      end
    end

    context 'multiple definitions of a route' do
      it 'works with HTTP_USER_AGENT' do
        app = Sinatra.new do
          user_agent(/Mozilla/)
          get '/' do
            [201, {}, 'Mozilla']
          end
          get '/' do
            [201, {}, 'not Mozilla']
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'HTTP_USER_AGENT' => 'Mozilla', 'rack.input' => ''
        expect(response[2]).to be == ['Mozilla']

        response = app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => ''
        expect(response[2]).to be == ['not Mozilla']
      end
    end

    context "params" do
      it "supports params like /hello/:name" do
        app = Sinatra.new do
          get '/Hello/:name' do
            [201, {}, ["Hello #{params[:name]}!"]]
          end
        end
        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/Hello/Horst', 'rack.input' => ''
        expect(response[2]).to be == ["Hello Horst!"]
      end

      it "exposes params with indifferent hash" do
        app = Sinatra.new do
          get '/:foo' do
            bar = params['foo']
            bar = params[:foo]
            [201, {}, 'ok']
          end
        end
        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/bar', 'rack.input' => ''
        expect(response[2]).to be == ['ok']
      end

      it "merges named params and query string params in params" do
        app = Sinatra.new do
          get '/:foo' do
            bar = params['foo']
            biz = params[:bar]
            [201, {}, '']
          end
        end
        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/biz', 'rack.input' => ''
        expect(response[0]).to be == 201
      end

      it "supports optional named params like /?:foo?/?:bar?" do
        app = Sinatra.new do
          get '/?:foo?/?:bar?' do
            [201, {}, ["foo=#{params[:foo]};bar=#{params[:bar]}"]]
          end
        end
        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello/world', 'rack.input' => ''
        expect(response[2]).to be == ["foo=hello;bar=world"]

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello', 'rack.input' => ''
        expect(response[2]).to be == ["foo=hello;bar="]

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'rack.input' => ''
        expect(response[2]).to be == ["foo=;bar="]
      end
    end

    context "pattern matching" do
      it "supports named captures like %r{/hello/(?<person>[^/?#]+)}" do
        app = Sinatra.new do
          get Regexp.new('/hello/(?<person>[^/?#]+)') do
            [201, {}, ["Hello #{params['person']}"]]
          end
        end
        
        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello/Frank', 'rack.input' => ''
        expect(response[2]).to be == ["Hello Frank"]
      end

      it "supports optional named captures like %r{/page(?<format>.[^/?#]+)?}" do
        app = Sinatra.new do
         get Regexp.new('/page(?<format>.[^/?#]+)?') do
          [201, {}, ["format=#{params[:format]}"]]
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/page.html', 'rack.input' => ''
        expect(response[2]).to be == ["format=.html"]

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/page.xml', 'rack.input' => ''
        expect(response[2]).to be == ["format=.xml"]

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/page', 'rack.input' => ''
        expect(response[2]).to be == ["format="]
      end

      it "supports single splat params like /*" do
        app = Sinatra.new do
          get '/*' do
            [201, {}, "#{params["splat"].join}"]
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
            [201, {}, "#{params["splat"].join(" ")}"]
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
            [201, {}, ""]
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo/bar/baz', 'rack.input' => ''
        expect(response[0]).to be == 201
      end

      context 'does not concatinate params with the same name' do
        let(:app) do
          Sinatra.new do
            get('/:foo') { [201, {}, [params[:foo]]] }
          end
        end

        let(:response){ get '/a?foo=b' }
        it("will take the first param only") { expect(response.body).to be == 'a'}
      end
    end

    context "special characters" do
      it "matches a dot ('.') as part of a named param" do
        app = Sinatra.new do
          get '/:foo/:bar' do
            [201, {}, "#{params[:foo]}"]
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/user@example.com/name', 'rack.input' => ''
        expect(response[0]).to be == 201
        expect(response[2]).to be == ['user@example.com']
      end

      it "matches a literal dot ('.') outside of named params" do
        app = Sinatra.new do
          get '/:file.:ext' do
            [201, {}, ""]
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/pony.jpg', 'rack.input' => ''
        expect(response[0]).to be == 201
      end

      it "literally matches dot in paths" do
        app = Sinatra.new do
          get '/test.bar' do
            [201, {}, ""]
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
            [201, {}, ""]
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo$', 'rack.input' => ''
        expect(response[0]).to be == 201
      end

      it "literally matches plus sign in paths" do
        app = Sinatra.new do
          get '/fo+o' do
            [201, {}, ""]
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
            [201, {}, "#{params[:foo]}"]
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/baz+bar', 'rack.input' => ''
        expect(response[2]).to be == ["baz+bar"]
      end

      it "literally matches parenthese in paths" do
        app = Sinatra.new do
          get '/foo(bar)' do
            [201, {}, ""]
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo(bar)', 'rack.input' => ''
        expect(response[0]).to be == 201
      end

      it "matches paths that include spaces encoded with %20 or +" do
        app = Sinatra.new do
          get '/path with spaces' do
            [201, {}, ""]
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/path%20with%20spaces', 'rack.input' => ''
        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/path+with+spaces', 'rack.input' => ''
        expect(response[0]).to be == 201
      end

      it "matches paths that include ampersands" do
        app = Sinatra.new do
          get '/:foo' do
            [201, {}, "#{params[:foo]}"]
          end
        end

        response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/bar&baz', 'rack.input' => ''
        expect(response[2]).to be == ['bar&baz']
      end

    end

  end
end
