# encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'

# returns response immediately on halt
# halts with a response tuple
# halts with an array of strings
# sets response.status with halt
# transitions to the next matching route on pass
# transitions to 404 when passed and no subsequent route matches
# transitions to 404 and sets X-Cascade header when passed and no subsequent route matches
# uses optional block passed to pass as route block if no other route is found
# matches routes defined in superclasses
# matches routes in subclasses before superclasses
# allows using call to fire another request internally
# plays well with other routing middleware