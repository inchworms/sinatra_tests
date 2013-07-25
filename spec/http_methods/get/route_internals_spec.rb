# encoding: utf-8

require 'spec_helper'

describe "GET route internals" do

	it 'returns the route signature'

  it "sets env['sinatra.route'] to the matched route" do

    verifier = Proc.new { |params| 
        expect(request.env['sinatra.route']).to be == ["users/:id/status"]    
      }

  	app = Sinatra.new do 
  		after do 
  			verifier.call(params)
  		end
  		get '/users/:id/status' do
  			[201, {} ["ok"]]
  		end
  	end
  	response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/users/1/status', 'rack.input' => ''
  end

end


# --------------------------------------------------
# old test
 # it "sets env['sinatra.route'] to the matched route" do
 #    mock_app do
 #      after do
 #        assert_equal 'GET /users/:id/status', env['sinatra.route']
 #      end
 #      get('/users/:id/status') { 'ok' }
 #    end
 #    get '/users/1/status'
 #  end
 #--------------------

 
 