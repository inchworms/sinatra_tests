describe "http methods" do 
	# these tests should include 
	# get, post, delete, head, put, options (all part of rfc2616)
	# patch
	# link, unlink

	describe "get" do
		it "should send the correct response" do

			expect response.body == "Hello World"
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

