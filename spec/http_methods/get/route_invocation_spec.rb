# 'encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'

describe 'GET route invocations'do 

	it 'passes a single url param as block parameters when one param is specified'
	it 'passes multiple params as block parameters when many are specified'
	it 'passes regular expression captures as block parameters'
	it 'supports mixing multiple splat params like /*/foo/*/* as block parameters'
	it 'raises an ArgumentError with block arity > 1 and too many values'
	it 'raises an ArgumentError with block param arity > 1 and too few values'
	it 'succeeds if no block parameters are specified'
	it 'passes all params with block param arity -1 (splat args)'
	it 'raises an ArgumentError with block param arity 1 and no values'
	it 'raises an ArgumentError with block param arity 1 and too many values'

end