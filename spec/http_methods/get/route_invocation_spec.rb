# encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'


# passes a single url param as block parameters when one param is specified
# passes multiple params as block parameters when many are specified
# passes regular expression captures as block parameters
# supports mixing multiple splat params like /*/foo/*/* as block parameters
# raises an ArgumentError with block arity > 1 and too many values
# raises an ArgumentError with block param arity > 1 and too few values
# succeeds if no block parameters are specified
# passes all params with block param arity -1 (splat args)
# raises an ArgumentError with block param arity 1 and no values
# raises an ArgumentError with block param arity 1 and too many values