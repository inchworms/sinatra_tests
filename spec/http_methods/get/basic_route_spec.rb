# encoding: utf-8

require 'spec_helper'

describe "GET basic '/' route" do
  let(:app) do
    Sinatra.new do
      get('/'){ [201, { 'Header' => 'foo' }, ["a", "b", "c"]] }
    end
  end
  let(:response){ get '/' }
  # does the same as:
  # let(:response) { @app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => '' }

  it("returns 201 as a status") { expect(response.status).to be == 201 }
  it("returns the complete body as string") { expect(response.body).to be == 'abc' }
  it("sets a header as foo") { expect(response.header['Header']).to be == 'foo' }

  it "/hello routes gets hello route" do
    app = Sinatra.new do
      get '/hello' do
        [ 201, {}, '' ]
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello', 'rack.input' => ''
    expect(response[0]).to be == 201
  end
end
