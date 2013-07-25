# encoding: utf-8

require 'spec_helper'
require 'stringio'

describe " GET returning an IO-like object" do
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