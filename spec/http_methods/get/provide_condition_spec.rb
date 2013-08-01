# 'encoding: utf-8

require 'spec_helper'

describe 'GET provide conditions' do
# mime-types or content-types two-part identifier for file formats on the Internet
# a type, a subtype, and zero or more optional parameters
  %w(
  application/atom+xml
  application/ecmascript
  application/EDI-X12
  application/EDIFACT
  application/json
  application/javascript
  application/octet-stream
  application/ogg
  application/pdf
  application/postscript
  application/rdf+xml
  application/rss+xml
  application/soap+xml
  application/font-woff
  application/xhtml+xml
  application/xml
  application/xml-dtd
  application/xop+xml
  application/zip
  application/gzip
  audio/basic
  audio/L24
  audio/mp4
  audio/mpeg
  audio/ogg
  audio/vorbis
  audio/vnd.rn-realaudio
  audio/vnd.wave
  audio/webm
  image/gif
  image/jpeg
  image/pjpeg
  image/png
  image/svg+xml
  image/tiff
  image/vnd.microsoft.icon
  message/http
  message/imdn+xml
  message/partial
  message/rfc822
  model/example
  model/iges
  model/mesh
  model/vrml
  model/x3d+binary
  model/x3d+vrml
  model/x3d+xml
  multipart/mixed
  multipart/alternative
  multipart/related
  multipart/form-data
  multipart/signed
  multipart/encrypted
  text/cmd
  text/css
  text/csv
  text/html
  text/javascript
  application/javascript
  text/plain
  text/vcard
  text/xml
  video/mpeg
  video/mp4
  video/ogg
  video/quicktime
  video/webm
  video/x-matroska
  video/x-ms-wmv
  video/x-flv
  application/vnd.oasis.opendocument.text
  application/vnd.oasis.opendocument.spreadsheet
  application/vnd.oasis.opendocument.presentation
  application/vnd.oasis.opendocument.graphics
  application/vnd.ms-excel
  application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
  application/vnd.ms-powerpoint
  application/vnd.openxmlformats-officedocument.presentationml.presentation
  application/vnd.openxmlformats-officedocument.wordprocessingml.document
  application/vnd.mozilla.xul+xml
  application/vnd.google-earth.kml+xml
  application/x-deb
  application/x-dvi
  application/x-font-ttf
  application/x-javascript
  application/x-latex
  application/x-mpegURL
  application/x-rar-compressed
  application/x-shockwave-flash
  application/x-stuffit
  application/x-tar
  application/x-www-form-urlencoded
  application/x-xpinstall
  audio/x-aac
  audio/x-caf
  image/x-xcf
  text/x-gwt-rpc
  text/x-jquery-tmpl
  application/x-pkcs12
  application/x-pkcs12
  application/x-pkcs7-certificates
  application/x-pkcs7-certificates
  application/x-pkcs7-certreqresp
  application/x-pkcs7-mime
  application/x-pkcs7-mime
  application/x-pkcs7-signature
  ).each do |mime_type|
    context mime_type do
      it "matches the mime_type" do
        expect(mime_type).to match(Sinatra::Request::HEADER_VALUE_WITH_PARAMS)
      end
    end
  end

  context 'filters by accept header' do
    let(:app) do
      Sinatra.new do
        get '/', :provides => :xml do
         env['HTTP_ACCEPT']
        end
        get('/foo', :provides => :html){ env['HTTP_ACCEPT'] }
        get('/stream', :provides => 'text/event-stream'){ env['HTTP_ACCEPT'] }
      end
    end
    # app = Sinatra.new do
    #   get '/', :provides => :xml do
    #     env['HTTP_ACCEPT']
    #   end
    #   get '/foo', :provides => :html do
    #     env['HTTP_ACCEPT']
    #   end
    #   get '/stream', :provides => 'text/event-stream' do
    #     env['HTTP_ACCEPT']
    #   end
    # end
    let(:response) { get '/', {'HTTP_ACCEPT' => 'application/xml'} }
    it("returns the correct xml content-type header") { expect(response.header['Content-Type']).to be == 'application/xml;charset=utf-8' }
    it("returns the correct body") { expect(response.body).to be == 'application/xml;charset=utf-8' }

    
    let(:response) { get '/', {'HTTP_ACCEPT' => ''} }
    it("returns the correct default content-type header") { expect(response.header['Content-Type']).to be == 'application/xml;charset=utf-8' }
    it("returns the correct body") { expect(response.body).to be == '' }

    let(:response) { get '/', {'HTTP_ACCEPT' => '*/*'} }
    it("returns the correct splat content-type header") { expect(response.header['Content-Type']).to be == 'application/xml;charset=utf-8' }
    it("returns the correct body") { expect(response.body).to be == '*/*' }

    let(:response) { get '/', {'HTTP_ACCEPT' => 'text/html;q=0.9'} }
    it("returns a 404") { expect(response.status).to be == 404 }

    # response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'HTTP_ACCEPT' => 'text/html;q=0.9', 'rack.input' => ''
    # expect(response[0]).to be == 200
    # expect(response[2]).to be == ['text/html;q=0.9']

    # response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'HTTP_ACCEPT' => '','rack.input' => ''
    # expect(response[0]).to be == 200
    # expect(response[2]).to be == ['']

    # response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'HTTP_ACCEPT' => '*/*', 'rack.input' => ''
    # expect(response[0]).to be == 200
    # expect(response[2]).to be == ['*/*']

    # response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'HTTP_ACCEPT' => 'application/xml', 'rack.input' => ''
    # expect(response[0]).to be == 404

    # response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stream', 'HTTP_ACCEPT' => 'text/event-stream', 'rack.input' => ''
    # expect(response[0]).to be == 200
    # expect(response[2]).to be == ['text/event-stream']

    # response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stream', 'HTTP_ACCEPT' => '', 'rack.input' => ''
    # expect(response[0]).to be == 200
    # expect(response[2]).to be == ['']
 
    # response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stream', 'HTTP_ACCEPT' => '*/*', 'rack.input' => ''
    # expect(response[0]).to be == 200
    # expect(response[2]).to be == ['*/*']

    # response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stream', 'HTTP_ACCEPT' => 'application/xml', 'rack.input' => ''
    # expect(response[0]).to be == 404

  end



  it 'filters by current Content-Type' do
    app = Sinatra.new do
      before('/txt') { content_type :txt }
      get '*', :provides => :txt do
        'txt'
      end
      before('/html') { content_type :html }
      get '*', :provides => :html do
        'html'
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => '*/*', 'rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[1]['Content-Type']).to be == 'text/plain;charset=utf-8'
    expect(response[2]).to be == ['txt']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/txt', 'HTTP_ACCEPT' => 'text/plain', 'rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[1]['Content-Type']).to be == 'text/plain;charset=utf-8'
    expect(response[2]).to be == ['txt']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'text/html', 'rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[1]['Content-Type']).to be == 'text/html;charset=utf-8'
    expect(response[2]).to be == ['html']

  end

  it 'allows multiple mime types for accept header' do
    types = ['image/jpeg', 'image/pjpeg']

    app = Sinatra.new do
      get '/', :provides => types do
        env['HTTP_ACCEPT']
      end
    end

    types.each do |type|
      response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => type, 'rack.input' => ''
      expect(response[0]).to be == 200
      expect(response[1]['Content-Type']).to be == type
      expect(response[2]).to be == [type]
    end
  end

  it 'respects user agent preferences for the content type' do
    app = Sinatra.new do
      get '/', :provides => [:png, :html] do
        content_type
      end
    end

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'image/png;q=0.5,text/html;q=0.8', 'rack.input' => ''
    expect(response[2]).to be == ['text/html;charset=utf-8']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'image/png;q=0.8,text/html;q=0.5', 'rack.input' => ''
    expect(response[2]).to be == ['image/png']

  end

  it 'accepts generic types' do
    app = Sinatra.new do
      get '/', :provides => :xml do
        content_type
      end
      get '/' do
        'no match'
      end
    end

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'foo/*', 'rack.input' => ''
    expect(response[2]).to be == ['no match']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'application/*', 'rack.input' => ''
    expect(response[2]).to be == ['application/xml;charset=utf-8']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => '*/*', 'rack.input' => ''
    expect(response[2]).to be == ['application/xml;charset=utf-8']

  end


  it 'prefers concrete over partly generic types' do
    app = Sinatra.new do
      get '/', :provides => [:png, :html] do
       content_type
     end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'image/*, text/html', 'rack.input' => ''
    expect(response[2]).to be == ['text/html;charset=utf-8']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'image/png, text/*', 'rack.input' => ''
    expect(response[2]).to be == ['image/png']

  end

  it 'prefers concrete over fully generic types' do
    app = Sinatra.new do
      get '/', :provides => [:png, :html] do
       content_type
     end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => '*/*, text/html', 'rack.input' => ''
    expect(response[2]).to be == ['text/html;charset=utf-8']
    
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'image/png, */*', 'rack.input' => ''
    expect(response[2]).to be == ['image/png']
  end

  it 'prefers partly generic over fully generic types' do
    app = Sinatra.new do
      get '/', :provides => [:png, :html] do
        content_type
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => '*/*, text/*', 'rack.input' => ''
    expect(response[2]).to be == ['text/html;charset=utf-8']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'image/*, */*', 'rack.input' => ''
    expect(response[2]).to be == ['image/png']
  end

  it 'respects quality with generic types' do
    app = Sinatra.new do
      get '/', :provides => [:png, :html] do
        content_type
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'image/*;q=1, text/html;q=0', 'rack.input' => ''
    expect(response[2]).to be == ['image/png']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'image/png;q=0.5, text/*;q=0.7', 'rack.input' => ''
    expect(response[2]).to be == ['text/html;charset=utf-8']
  end

  it 'supplies a default quality of 1.0' do
    app = Sinatra.new do
      get '/', :provides => [:png, :html] do
        content_type
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'image/png;q=0.5, text/*', 'rack.input' => ''
    expect(response[2]).to be == ['text/html;charset=utf-8']
  end

  it 'orders types with equal quality by parameter count' do
    app = Sinatra.new do
      get '/', :provides => [:png, :jpg] do
        content_type
      end
    end

    lo_png = 'image/png;q=0.5'
    hi_png = 'image/png;q=0.5;profile=FOGRA40;gamma=0.8'
    jpeg = 'image/jpeg;q=0.5;compress=0.25'

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => "#{lo_png}, #{jpeg}", 'rack.input' => ''
    expect(response[2]).to be == ['image/jpeg']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => "#{hi_png}, #{jpeg}", 'rack.input' => ''
    expect(response[2]).to be == ['image/png']
  end

  it 'ignores the quality parameter when ordering by parameter count' do
    app = Sinatra.new do
      get '/', :provides => [:png, :jpg] do
        content_type
      end
    end

    lo_png = 'image/png'
    hi_png = 'image/png;profile=FOGRA40;gamma=0.8'
    jpeg = 'image/jpeg;q=1.0;compress=0.25'

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => "#{jpeg}, #{lo_png}", 'rack.input' => ''
    expect(response[2]).to be == ['image/jpeg']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => "#{jpeg}, #{hi_png}", 'rack.input' => ''
    expect(response[2]).to be == ['image/png']
  end

  it 'poperly handles quoted strings in parameters' do
    app = Sinatra.new do
      get '/', :provides => [:png, :jpg] do
        content_type
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'image/png;q=0.5;profile=",image/jpeg,"', 'rack.input' => ''
    expect(response[2]).to be == ['image/png']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'image/png;q=0.5,image/jpeg;q=0;x=";q=1.0"', 'rack.input' => ''
    expect(response[2]).to be == ['image/png']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'image/png;q=0.5,image/jpeg;q=0;x="\";q=1.0"', 'rack.input' => ''
    expect(response[2]).to be == ['image/png']
  end

  it 'accepts both text/javascript and application/javascript for js' do
    app = Sinatra.new do
      get '/', :provides => :js do
        content_type
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'application/javascript', 'rack.input' => ''
    expect(response[2]).to be == ['application/javascript;charset=utf-8']
  end

  it 'accepts both text/xml and application/xml for xml' do
    app = Sinatra.new do
      get '/', :provides => :xml do
        content_type
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'application/xml', 'rack.input' => ''
    expect(response[2]).to be == ['application/xml;charset=utf-8']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'text/xml', 'rack.input' => ''
    expect(response[2]).to be == ['text/xml;charset=utf-8']
  end

end