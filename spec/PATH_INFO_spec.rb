# encoding: utf-8

require 'spec_helper'

describe "GET PATH_INFO" do
  context 'matches empty PATH_INFO to "/"' do
    let(:app) do
      Sinatra.new do
        get('/'){'working'}
      end
    end
    it "if no route is defined for ''" do
      response = get '', {}, {'PATH_INFO' => ''}
      expect(response.body).to be == 'working'
    end
  end

  context 'matches empty PATH_INFO to ""' do
    let(:app) do
      Sinatra.new do
        get('/'){ 'not working' }
        get(''){ 'working' }
      end
    end
    it "if a route is defined for ''" do
      response = get '', {}, {'PATH_INFO' => ''}
      expect(response.body).to be == 'working'
    end
  end
end