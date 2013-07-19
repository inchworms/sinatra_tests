require 'sinatra'
require 'stringio'
require 'support/rack'

describe "http methods" do 

	# these tests should include 
	# get, post, delete, head, put, options (all part of rfc2616)
	# patch
	# link, unlink

	describe "get" do

		context "/" do
			let(:app) do
				Sinatra.new do
					get('/') { [201, { 'Header' => 'foo' }, ["a", "b", "c"]] }
				end
			end
			let(:response) { get '/' }

			it("returns 201 as a status") { expect(response.status).to eq 201 }
			it("returns the complete body as string") { expect(response.body).to eq 'abc' }
			it("sets a header as foo") {expect(response.header['Header']).to eq 'foo'}
		end

		it "/hello routes gets hello route" do
			app = Sinatra.new do
				get '/hello' do
					[200, {}, '']
				end
			end
			response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello', 'rack.input' => ''
			expect(response[0]).to eq 200
		end

		context "returning an IO-like object" do
			before do
				@app = Sinatra.new do
					get '/' do
						StringIO.new("Hello World")
					end
				end
			end

			let(:response) { @app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => '' }

			it("returns 200 as Status") {expect(response[0]).to eq 200}
			it("returns the object's body") {expect(response[2].read).to eq "Hello World"}
		end

		it "returns empty array when body is nil" do
			app = Sinatra.new do
				get '/' do
					[200, {}, nil]
				end
			end
			response = app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => ''
			expect(response[2]).to eq []
		end

		it "supports params like /hello/:name" do
			app = Sinatra.new do
				get '/Hello/:name' do
					[200, {}, ["Hello #{params[:name]}!"]]
				end
			end
			response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/Hello/Horst', 'rack.input' => ''
			expect(response[2]).to eq ["Hello Horst!"]
		end

		it "throws error when not finding path" do
			app = Sinatra.new do
				get '/' do
					[200, {}, ""]
				end
			end
			response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/Hello', 'rack.input' => ''
			expect(response[0]).to eq 404
		end

	end
end



