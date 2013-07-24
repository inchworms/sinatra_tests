# 'encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'

describe 'GET route flow' do

	it 'returns response immediately on halt'
	it 'halts with a response tuple'
	it 'halts with an array of strings'
	it 'sets response.status with halt'
	it 'transitions to the next matching route on pass'
	it 'transitions to 404 when passed and no subsequent route matches'
	it 'transitions to 404 and sets X-Cascade header when passed and no subsequent route matches'
	it 'uses optional block passed to pass as route block if no other route is found'
	it 'matches routes defined in superclasses'
	it 'matches routes in subclasses before superclasses'
	it 'allows using call to fire another request internally'
	it 'plays well with other routing middleware'

end