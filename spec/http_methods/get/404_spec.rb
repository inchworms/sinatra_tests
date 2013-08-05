# encoding: utf-8

require 'spec_helper'

describe "GET 404" do
  let(:app){ Sinatra.new }
  let(:response){ get '/' }

  it "recalculates body length correctly for 404 response" do
    expect(response.body.length).to be == (response.header['Content-Length']).to_i
  end
end

