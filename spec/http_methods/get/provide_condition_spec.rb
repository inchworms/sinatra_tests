# 'encoding: utf-8

require 'spec_helper'

describe 'GET provide conditions' do

  it 'matches mime_types with dots, hyphens and plus signs' do
    mime_types = %w(
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
      )

    mime_types.each { |mime_type| expect(mime_type).to match(Sinatra::Request::HEADER_VALUE_WITH_PARAMS) }
  end

  it 'filters by accept header' do
    app = Sinatra.new do
      get '/', :provides => :xml do
        env['HTTP_ACCEPT']
      end
      get '/foo', :provides => :html do
        env['HTTP_ACCEPT']
      end
      get '/stream', :provides => 'text/event-stream' do
        env['HTTP_ACCEPT']
      end
    end
    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'application/xml', 'rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[1]['Content-Type']).to be == 'application/xml;charset=utf-8'
    expect(response[2]).to be == ['application/xml']
    # get '/', {}, { 'HTTP_ACCEPT' => 'application/xml' }
    # assert ok?
    # assert_equal 'application/xml', body
    # assert_equal 'application/xml;charset=utf-8', response.headers['Content-Type']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => '','rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[1]['Content-Type']).to be == 'application/xml;charset=utf-8'
    expect(response[2]).to be == ['']
    # get '/', {}, {}
    # assert ok?
    # assert_equal '', body
    # assert_equal 'application/xml;charset=utf-8', response.headers['Content-Type']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => '*/*', 'rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[1]['Content-Type']).to be == 'application/xml;charset=utf-8'
    expect(response[2]).to be == ['*/*']
    # get '/', {}, { 'HTTP_ACCEPT' => '*/*' }
    # assert ok?
    # assert_equal '*/*', body
    # assert_equal 'application/xml;charset=utf-8', response.headers['Content-Type']

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'text/html;q=0.9', 'rack.input' => ''
    expect(response[0]).to be == 404
    # get '/', {}, { 'HTTP_ACCEPT' => 'text/html;q=0.9' }
    # assert !ok?

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'HTTP_ACCEPT' => 'text/html;q=0.9', 'rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[2]).to be == ['text/html;q=0.9']
    # get '/foo', {}, { 'HTTP_ACCEPT' => 'text/html;q=0.9' }
    # assert ok?
    # assert_equal 'text/html;q=0.9', body

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'HTTP_ACCEPT' => '','rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[2]).to be == ['']
    # get '/foo', {}, { 'HTTP_ACCEPT' => '' }
    # assert ok?
    # assert_equal '', body

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'HTTP_ACCEPT' => '*/*', 'rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[2]).to be == ['*/*']
    # get '/foo', {}, { 'HTTP_ACCEPT' => '*/*' }
    # assert ok?
    # assert_equal '*/*', body

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/foo', 'HTTP_ACCEPT' => 'application/xml', 'rack.input' => ''
    expect(response[0]).to be == 404
    # get '/foo', {}, { 'HTTP_ACCEPT' => 'application/xml' }
    # assert !ok?

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stream', 'HTTP_ACCEPT' => 'text/event-stream', 'rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[2]).to be == ['text/event-stream']
    # get '/stream', {}, { 'HTTP_ACCEPT' => 'text/event-stream' }
    # assert ok?
    # assert_equal 'text/event-stream', body

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stream', 'HTTP_ACCEPT' => '', 'rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[2]).to be == ['']
    # get '/stream', {}, { 'HTTP_ACCEPT' => '' }
    # assert ok?
    # assert_equal '', body

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stream', 'HTTP_ACCEPT' => '*/*', 'rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[2]).to be == ['*/*']
    # get '/stream', {}, { 'HTTP_ACCEPT' => '*/*' }
    # assert ok?
    # assert_equal '*/*', body

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/stream', 'HTTP_ACCEPT' => 'application/xml', 'rack.input' => ''
    expect(response[0]).to be == 404
    # get '/stream', {}, { 'HTTP_ACCEPT' => 'application/xml' }
    # assert !ok?
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
    # mock_app do
    #   before('/txt') { content_type :txt }
    #   get('*', :provides => :txt) { 'txt' }

    #   before('/html') { content_type :html }
    #   get('*', :provides => :html) { 'html' }
    # end

    # get '/', {}, { 'HTTP_ACCEPT' => '*/*' }
    # assert ok?
    # assert_equal 'text/plain;charset=utf-8', response.headers['Content-Type']
    # assert_body 'txt'

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/txt', 'HTTP_ACCEPT' => 'text/plain', 'rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[1]['Content-Type']).to be == 'text/plain;charset=utf-8'
    expect(response[2]).to be == ['txt']
    # get '/txt', {}, { 'HTTP_ACCEPT' => 'text/plain' }
    # assert ok?
    # assert_equal 'text/plain;charset=utf-8', response.headers['Content-Type']
    # assert_body 'txt'

    response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'HTTP_ACCEPT' => 'text/html', 'rack.input' => ''
    expect(response[0]).to be == 200
    expect(response[1]['Content-Type']).to be == 'text/html;charset=utf-8'
    expect(response[2]).to be == ['html']
    # get '/', {}, { 'HTTP_ACCEPT' => 'text/html' }
    # assert ok?
    # assert_equal 'text/html;charset=utf-8', response.headers['Content-Type']
    # assert_body 'html'
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

    # it "allows multiple mime types for accept header" do
    # types = ['image/jpeg', 'image/pjpeg']

    # mock_app {
    #   get '/', :provides => types do
    #     env['HTTP_ACCEPT']
    #   end
    # }

    # types.each do |type|
    #   get '/', {}, { 'HTTP_ACCEPT' => type }
    #   assert ok?
    #   assert_equal type, body
    #   assert_equal type, response.headers['Content-Type']
    # end
  end

  it 'respects user agent preferences for the content type' do



    # mock_app { get('/', :provides => [:png, :html]) { content_type }}
    # get '/', {}, { 'HTTP_ACCEPT' => 'image/png;q=0.5,text/html;q=0.8' }
    # assert_body 'text/html;charset=utf-8'
    # get '/', {}, { 'HTTP_ACCEPT' => 'image/png;q=0.8,text/html;q=0.5' }
    # assert_body 'image/png'
  end

  it 'accepts generic types'
  it 'prefers concrete over partly generic types'
  it 'prefers concrete over fully generic types'
  it 'prefers partly generic over fully generic types'
  it 'respects quality with generic types'
  it 'supplies a default quality of 1.0'
  it 'orders types with equal quality by parameter count'
  it 'ignores the quality parameter when ordering by parameter count'
  it 'poperly handles quoted strings in parameters'
  it 'accepts both text/javascript and application/javascript for js'
  it 'accepts both text/xml and application/xml for xml'

end