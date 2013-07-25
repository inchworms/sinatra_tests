# encoding: utf-8

require 'spec_helper'

describe "GET missing routes" do
  let(:app) { Sinatra.new }
  let(:response) { get '/noroute' }

  it("sets X-Cascade header when no route satisfies the request") { expect(response.header['X-Cascade']).to be == 'pass' }
  it("throws an 404") { expect(response.status).to be == 404 }

  it "does not set X-Cascade header when x_cascade has been disabled" do
    app.disable :x_cascade
    expect(response.header).to_not include("X-Cascade")
  end
end

