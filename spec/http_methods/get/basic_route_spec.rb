# encoding: utf-8

require 'spec_helper'

describe "GET basic '/' route" do
  let(:app) do
    Sinatra.new do
      get('/'){ [201, { 'Header' => 'foo' }, ["a", "b", "c"]] }
    end
  end
  let(:response){ get '/' }
  it("returns 201 as a status"){ expect(response.status).to be == 201 }
  it("sets the header as foo"){ expect(response.header['Header']).to be == 'foo' }
  it("returns the complete body as string"){ expect(response.body).to be == 'abc' }

  context "/hello routes" do
    let(:app) do
      Sinatra.new do
        get('/hello'){ 'working' }
      end
    end
    let(:response){ get'/hello' }
    it("gets hello route"){ expect(response.body).to be == "working" }
  end
end
