# encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'

# passes to next route when condition calls pass explicitly
# passes when matching condition returns false
# does not pass when matching condition returns nil
# allows custom route-conditions to be set via route options

# describe "get request" do
# 	context "conditions" do
# 	end
# end
