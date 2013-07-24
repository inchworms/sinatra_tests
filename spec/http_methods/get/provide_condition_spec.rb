# 'encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'

describe 'GET provide conditions' do

	it 'matches mime_types with dots, hyphens and plus signs'
	it 'filters by accept header'
	it 'filters by current Content-Type'
	it 'allows multiple mime types for accept header'
	it 'respects user agent preferences for the content type'
	it 'accepts generic types'
	it 'prefers concrete over partly generic types'
	it 'prefers concrete over fully generic types'
	it 'prefers partly generic over fully generic types'
	it 'respects quality with generic types'
	it 'supplies a default quality of 1.0'
	it 'orders types with equal quality by parameter count'
	it 'ignores the quality parameter when ordering by parameter count'
	it 'properly handles quoted strings in parameters'
	it 'accepts both text/javascript and application/javascript for js'
	it 'accepts both text/xml and application/xml for xml'

end