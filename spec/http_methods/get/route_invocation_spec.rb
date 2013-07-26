# encoding: utf-8
require 'spec_helper'

describe 'GET route invocations'do 

	it 'passes a single url param as block parameters when one param is specified'
	it 'passes multiple params as block parameters when many are specified'


context 'passes regular expression' do
  let(:app) do
    Sinatra.new do 
      get (/^\/fo(.*)\/ba(.*)/) do |foo, bar|
        [201, {}, params[:captures]]       
      end
    end
  end

  it 'correctly captures as block parameters' do  
    expect(get('/foorooomma/baf').body).to be == ["foorooomma/baf"]
    expect(get('/foorooomma/baf').status).to be == 201
  end

end



#     mock_app {
#       get(/^\/fo(.*)\/ba(.*)/) do |foo, bar|
#         assert_equal 'orooomma', foo
#         assert_equal 'f', bar
#         'looks good'
#       end
#     }

#     get '/foorooomma/baf'
#     assert ok?
#     assert_equal 'looks good', body


	
  context "mixing multiple splat params like /*/foo/*/*" do

    let(:app) do
      Sinatra.new do
        get '/*/foo/*/*' do
          params['splat'].join "\n"
        end
      end
    end

    it 'correctly extracts the parameters' do  
      expect(get('/bar/foo/bling/baz/boom').body).to be == "bar\nbling\nbaz/boom"
    end
       
    it 'returns a 404 if not enough splats are provided' do 
      expect(get('/bar/foo/baz').status).to be == 404
    end
  end
	

  it 'succeeds if no block parameters are specified' do
    app = Sinatra.new do
      get '/:foo/:bar' do 
        'quux'
      end
    end

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/a/b', 'rack.input' => ''
    expect(response[2]).to be == ['quux']      
  end

  
  it 'passes all params with block param arity -1 (splat args)' do 
    app = Sinatra.new do 
      get '/:foo/:bar' do |*args|
        args.join
      end
    end

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/a/b', 'rack.input' => ''
    expect(response[2]).to be == ['ab']  
  end

  
  context 'it' do
    let(:app) do
      Sinatra.new do 
        get ('/:foo/:bar/:baz') do |foo, bar|
          [201, {}, ["quux"]] 
        end
      end
    end

    it ('raises an ArgumentError with block arity > 1 and too many values') do
      expect { get '/a/b/c' }.to raise_error(ArgumentError)
    end
  end


  context 'it' do
    let(:app) do
      Sinatra.new do
        get('/:foo/:bar/:baz') do |foo|
          [201, {}, ["quux"]] 
        end
      end
    end

    it("raises an ArgumentError with block param arity 1 and too many values") do
      expect { get '/a/b/c' }.to raise_error(ArgumentError)
    end
  end

  context "it" do
    let(:app) do
      Sinatra.new do
        get('/foo') do |foo|
          [201, {}, ["quux"]] 
        end
      end
    end

    it("raises an ArgumentError with block param arity 1 and no values") do
      expect { get '/foo' }.to raise_error(ArgumentError)
    end
  end

  context "it" do
    let(:app) do
      Sinatra.new do
        get('/:foo/:bar') do |foo, bar, baz|
    			[201, {}, ["quux"]] 
    		end
      end
    end

    it("raises an ArgumentError with block param arity >1 and too few values") do 
    	expect { get '/a/b' }.to raise_error(ArgumentError)
    end
  end

end