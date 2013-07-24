# encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'

# passes to the next route when user_agent does not match
# treats missing user agent like an empty string
# makes captures in user agent pattern available in params[:agent]
# adds hostname condition when it is in options