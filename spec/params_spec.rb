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

  context "indifferent hash" do
    the_params = nil
    let(:app) do
      Sinatra.new do
        get '/:foo' do
          the_params = params.dup
        end
      end
    end
    it "exposes params with indifferent hash" do
      get '/bar'
      expect(the_params['foo']).to be == "bar"
      expect(the_params[:foo]).to be == "bar"
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
    it "merges /bar?baz=biz params correctly" do
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
    it "both /carla/berlin params are set" do
      response = get'/carla/berlin'
      expect(response.body).to be == "Name=carla;City=berlin"
    end

    it "one param /carla is set" do
      response = get'/carla'
      expect(response.body).to be == "Name=carla;City="
    end

    it "no param is set" do
      response = get'/'
      expect(response.body).to be == "Name=;City="
    end
  end

  context "nested params" do
   
    the_params = nil

    let(:app) do
      Sinatra.new do
        get '/foo' do
          the_params = params.dup
        end
      end
    end

    it "exposes nested params with indifferent hash" do
      get '/foo?bar[][foo]=baz'
      expect(the_params["bar"][0][:foo]).to eql("baz")
      expect(the_params["bar"][0]["foo"]).to eql("baz")
    end

    it "supports arrays within params" do
      response = get '/foo?bar[]=A&bar[]=B'
      expect(the_params[:bar]).to be == ["A", "B"]
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

      get '/foo', expected_params
      expect(the_params).to be == expected_params
    end
  end

  context "non-nested params" do
    let(:app) do
      Sinatra.new do
        get('/foo'){ "article_id = #{params['article_id']}; comment = #{params['comment']['body']}" }
      end
    end
    let(:response){ get '/foo?article_id=2&comment[body]=awesome' }
    it("preserves /foo?article_id=2&comment[body]=awesome"){ expect(response.body).to be == "article_id = 2; comment = awesome" }
  end
end
