# encoding: utf-8

require 'spec_helper'

describe "GET params" do
  context "supports params" do
    let(:app) do
      Sinatra.new do
        get('/Hello/:name'){ "Hello #{params[:name]}!" }
      end
    end
    it "supports params like /hello/:name" do
      response = get '/Hello/Horst'
      expect(response.body).to be == "Hello Horst!"
    end
  end
#TODO: some explanation!
  context "exposes params" do
    let(:app) do
      Sinatra.new do
        get '/:foo' do
          bar = params['foo']
          bar = params[:foo]
          "working"
        end
      end
    end
    it "with indifferent hash" do
      response = get '/bar'
      expect(response.body).to be == "working"
    end
  end

  context "both named and query string params" do
    the_params = nil
    let(:app) do
      Sinatra.new do
        get '/:foo' do
          the_params = params.dup
        end
      end
    end
    it "merges params correctly" do
      get '/bar?baz=biz'
      expect(the_params["foo"]).to be == "bar"
      expect(the_params["baz"]).to be == "biz"
    end
  end

  context "supports optional named params like /?:name?/?:city?" do
    let(:app) do
      Sinatra.new do
        get('/?:name?/?:city?'){ "Name=#{params[:name]};City=#{params[:city]}" }
      end
    end
    it "both params are set" do
      response = get'/carla/berlin'
      expect(response.body).to be == "Name=carla;City=berlin"
    end

    it "one param is set" do
      response = get'/carla'
      expect(response.body).to be == "Name=carla;City="
    end

    it "no param is set" do
      response = get'/'
      expect(response.body).to be == "Name=;City="
    end
  end

  context "nested params" do
    def app
      @app
    end
    # TODO: really need a Proc?
    # https://github.com/sinatra/sinatra/blob/master/test/routing_test.rb#L392
    it "exposes nested params with indifferent hash" do
      verifier = Proc.new { |params|
        expect(params["bar"][0][:foo]).to eql("baz")
        expect(params["bar"][0]["foo"]).to eql("baz")
      }
      @app = Sinatra.new do
        get '/foo' do
          verifier.call(params)
          [201, {}, '']
        end
      end
      response = get '/foo?bar[][foo]=baz'
      expect(response.status).to be == 201
    end

    it "supports arrays within params" do
      verifier = Proc.new { |params|
        expect(params[:bar]).to be == ["A", "B"]
      }
      @app = Sinatra.new do
        get '/foo' do
          verifier.call(params)
          [201, {}, '']
        end
      end
      response = get '/foo?bar[]=A&bar[]=B'
      expect(response.status).to be == 201
    end

    it "supports deeply nested params" do
      expected_params = {
                      "emacs" => {
                                  "map"     => { "goto-line" => "M-g g" },
                                  "version" => "22.3.1"
                                  },
                      "browser" => {
                                  "firefox" => {"engine" => {"name"=>"spidermonkey", "version"=>"1.7.0"}},
                                  "chrome"  => {"engine" => {"name"=>"V8", "version"=>"1.0"}}
                                  },
                      "paste" => {"name"=>"hello world", "syntax"=>"ruby"}
      }

      verifier = ->(params) { expect(params).to be == expected_params }
      @app = Sinatra.new do
        get '/foo' do
          verifier.call(params)
          [201, {}, '']
        end
      end
      response = get '/foo', expected_params
      expect(response.status).to be == 201
    end
  end

  context "non-nested params" do
    let(:app) do
      Sinatra.new do
        get('/foo'){ "article_id = #{params['article_id']}; comment = #{params['comment']['body']}" }
      end
    end
    let(:response){ get '/foo?article_id=2&comment[body]=awesome' }
    it("preserves non-nested params"){ expect(response.body).to be == "article_id = 2; comment = awesome" }
  end
end
