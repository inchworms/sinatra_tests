# encoding: utf-8

require 'spec_helper'

describe "GET conditions" do
  context "passes to next route when condition calls pass explicitly" do
    let(:app) do
      Sinatra.new do
        condition do
          pass unless params[:foo] == 'bar'
        end
        get('/:foo'){ }
      end
    end

    context "get /bar" do
      let(:response){ get '/bar' }
      it("returns expected status"){ expect(response.status).to be == 200 }
    end
    
    context "get /foo" do
      let(:response){ get '/foo' }
      it("returns expected status"){ expect(response.status).to be == 404 }
    end
  end

  context "passes when matching condition returns false" do
    let(:app) do
      Sinatra.new do
        condition do
          params[:foo] == 'bar'
        end
        get('/:foo'){ }
      end
    end

    context "/bar" do
      let(:response){ get '/bar' }
      it("returns expected status"){ expect(response.status).to be == 200 }
    end

    context "/foo" do
      let(:response){ get '/foo' }
      it("returns expected status"){ expect(response.status).to be == 404 }
    end
  end

  context "does not pass when matching condition returns nil" do
    let(:app) do
      Sinatra.new do
        condition do
          nil
        end
        get('/:foo'){ }
      end
    end

   let(:response){ get '/bar' }
   it("returns expected status"){ expect(response.status).to be == 200 }
  end

  context 'allows custom route-conditions to be set via route options' do
    protector = Module.new do
      def protect(*args)
        condition do
          unless authorize(params["user"], params["password"])
            halt 403, "not authorized"
          end
        end
      end
    end

    let(:app) do
      Sinatra.new do
        register protector

        helpers do
          def authorize(username, password)
            username == "foo" && password == "bar"
          end
        end
        get("/", :protect => true){ 'authorized' }
      end
    end

    context "get / without user and password" do
      let(:response){ get '/' }
      it("return status 403"){ expect(response.status).to be == 403 }
      it("returns correct body"){ expect(response.body).to be == "not authorized" }
    end

    context "get / with username and password" do
      let(:response){ get '/', {}, {'QUERY_STRING' => 'user=foo&password=bar'} }
      it("return status 200"){ expect(response.status).to be == 200 }
      it("return correct body"){ expect(response.body).to be == 'authorized' }
    end
  end

end
