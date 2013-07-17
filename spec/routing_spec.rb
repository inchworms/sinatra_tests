require 'sinatra'

describe "http methods" do 
	# these tests should include 
	# get, post, delete, head, put, options (all part of rfc2616)
	# patch
	# link, unlink

	describe "get" do
		it "should return 200 as a status" do

			#context returning full rack response [200, {}, ["body"]]
			#context returning the body as a string "Hello World!"
			#context returning the body as an array ["a", "b", "c"]
			#context returning the body as an io object File.open("source_file")
			app = Sinatra.new do 
				get '/' do
					[200, {}, 'Hello World']
				end
			end
			response = app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => ''
			expect(response[0]).to eq 200
		end
	end
end


# describe "settings" do
# these tests should include setting status, body, headers
#end


#describe "route flow" do
#  these tests should include before and after filters
#  and passing and halting
#end

