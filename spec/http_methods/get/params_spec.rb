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
#TODO: some explanation!
  context "merges named params and query string params in params" do
    let(:app) do
      Sinatra.new do
        get '/:foo' do
          bar = params['foo']
          biz = params['baz']
          "working"
        end
      end
    end
    it "" do
      response = get '/bar?baz=biz'
      expect(response.body).to be == "working"
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
    # this is throwing an error. it seems that 'expect' doesn't work within a sinatra route handler (i.e the get block)
    it("exposes nested params with indifferent hash") do
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

    it("supports arrays within params") do
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
        get '/foo' do
          [ 201, {}, "#{params['article_id']}; #{params['comment']['body']}" ]
        end
      end
    end
    let(:response){ get '/foo?article_id=2&comment[body]=awesome' }
    it("preserves non-nested params") { expect(response.status).to be == 201 }
    it("preserves non-nested params") { expect(response.body).to be == "2; awesome" }
  end
end
