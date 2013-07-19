require 'sinatra'
require 'stringio'

describe "http methods" do 
	# these tests should include 
	# get, post, delete, head, put, options (all part of rfc2616)
	# patch
	# link, unlink

			#context returning full rack response [200, {}, ["body"]]
			#context returning the body as a string "Hello World!"
			#context returning the body as an array ["a", "b", "c"]
			#context returning the body as an io object File.open("source_file")
	describe "get" do

		context "/" do
			before(:each) do
				@app = Sinatra.new do
					get '/' do
						[200, {}, ["a", "b", "c"]]
					end
				end
			end
			let(:response) { @app.call('REQUEST_METHOD' => 'GET', 'rack.input' => '') }

			it("returns 200 as a status") { expect(response[0]).to eq 200 }
			it("returns body as string") { expect(response[2][0]).to eq 'a' }
			it("returns body as array") { expect(response[2]).to eq ["a", "b", "c"] }
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
			it("returns the object's body") {expect(response.body).to eq "Hello World"}
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

		# it "allows using unicode" do
  #   	app = Sinatra.new do
  #     	get '/f%C3%B6%C3%B6' do
  #     		[200, {}, '']
  #     	end
  #   	end
  #   	response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/f%C3%B6%C3%B6', 'rack.input' => ''
		# 	p response.inspect
	 #   	expect(response[0]).to eq 200
  # 	end

	end
end


# describe "settings" do
# these tests should include setting status, body, headers
#end


#describe "route flow" do
#  these tests should include before and after filters
#  and passing and halting
#end

