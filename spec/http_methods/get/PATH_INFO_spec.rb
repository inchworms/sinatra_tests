# encoding: utf-8

require 'spec_helper'

describe "GET PATH_INFO" do
  context 'matches empty PATH_INFO to "/"' do
    let(:app) do
      Sinatra.new do
        get('/'){'working'}
      end
    end
    let(:response){ get '' }
    it("if no route is defined for"){ expect(response.body).to be == 'working' }
  end
#TODO: not working!
  context 'matches empty PATH_INFO to ""' do
    let(:app) do
      Sinatra.new do
        get '/' do
          'not working'
        end
        get '' do
          'working'
        end
      end
    end
    let(:response){ get '' }
    it("if a route is defined for"){ expect(response.body).to be == 'working' }
  end
end
# OLD TESTS:
  # # encoding: utf-8

  # require 'spec_helper'

  # describe "GET PATH_INFO" do
  #   it 'matches empty PATH_INFO to "/" if no route is defined for ""' do
  #     app = Sinatra.new do
  #       get '/' do
  #         [ 201, {}, '' ]
  #       end
  #     end
  #     response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '', 'rack.input' => ''
  #     expect(response[0]).to be == 201
  #   end

  #   it 'matches empty PATH_INFO to "" if a route is defined for ""' do
  #     app = Sinatra.new do
  #       get '/' do
  #         [ 201, {}, 'not working' ]
  #       end
  #       get '' do
  #         [ 201, {}, 'working' ]
  #       end
  #     end
  #     response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '', 'rack.input' => ''
  #     expect(response[2]).to be == ['working']
  #   end
  # end