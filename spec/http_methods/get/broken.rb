require 'sinatra/base'
require 'rack/test'
 
class Silly
  include Rack::Test::Methods
 
  def app
    Sinatra.new do
      get '/', provides: :xml do
        p env
        env['HTTP_ACCEPT'].to_s
      end
    end
  end
 
  def check
    p get '/', {'HTTP_ACCEPT' => 'application/xml'}
  end
end
    
r = Silly.new.check
p r.body
p r['Content-Type']