# encoding: utf-8

require 'spec_helper'

describe "GET body responses" do
  let(:app) do
    Sinatra.new do
      get('/'){ nil }
    end
  end
  it "returns empty string when body is nil" do
    response = get '/'
    expect(response.body).to be == ""
  end
end
