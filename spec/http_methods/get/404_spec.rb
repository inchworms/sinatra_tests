# encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'

describe "get request" do
	context "404" do
	  let(:app) { Sinatra.new }
	  let(:response) { get '/' }

	  it "recalculates body length correctly for 404 response" do
	    expect(response.body.length).to be == (response.header['Content-Length']).to_i
	  end
	end
end

