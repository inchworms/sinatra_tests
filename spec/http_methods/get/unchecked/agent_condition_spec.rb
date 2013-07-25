# encoding: utf-8

require 'spec_helper'

describe 'GET agent conditions' do
	it 'passes to the next route when user_agent does not match'
	it 'treats missing user agent like an empty string'
	it 'makes captures in user agent pattern available in params[:agent]'
	it 'adds hostname condition when it is in options'
end
