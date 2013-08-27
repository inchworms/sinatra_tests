# 'encoding: utf-8

require 'spec_helper'


shared_examples_for "it routes '/' correctly" do |request_type|
  #run the request_type thru our example Sinatra app
  let(:app) do
    Sinatra.new do
      send(request_type, '/'){ [201, { 'Header' => 'foo' }, ["a", "b", "c"]] }
    end
  end

  let(:response){ request "/", :method => request_type.to_s.upcase }
  it("returns 201 as a status"){ expect(response.status).to be == 201 }
  it("sets the header as foo"){ expect(response.header['Header']).to be == 'foo' }
  it("returns the complete body as string"){ expect(response.body).to be == 'abc' }
end

request_types = [:post, :put, :delete, :options, :patch, :link, :unlink]
request_types.each do |request_type|
  describe "#{request_type.upcase} request " do
    it_should_behave_like "it routes '/' correctly", request_type
  end
end



