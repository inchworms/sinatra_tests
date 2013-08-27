# 'encoding: utf-8

require 'spec_helper'

describe 'GET provide conditions' do
# mime-types or content-types two-part identifier for file formats on the Internet
# a type, a subtype, and zero or more optional parameters
  context 'matching mime types with dots, hyphens and plus signs' do
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
    #iterate through the above array to make a seperate test for each
    mime_types.each do |mime_type| 
      it "matches #{mime_type} correctly" do
        expect(mime_type).to match(Sinatra::Request::HEADER_VALUE_WITH_PARAMS)
      end
    end
  end

  context 'filters by accept header' do
    let(:app) do
      Sinatra.new do
        get('/', :provides => :xml){ env['HTTP_ACCEPT'].to_s }
        get('/foo', :provides => :html){ env['HTTP_ACCEPT'].to_s }
        get('/stream', :provides => 'text/event-stream'){ env['HTTP_ACCEPT'].to_s }
      end
    end

    context "when sent '/' and 'HTTP_ACCEPT' => 'application/xml'" do
      let(:response) { get '/', {}, {'HTTP_ACCEPT' => 'application/xml'} }
      it("returns the correct content-type header"){ expect(response.header['Content-Type']).to be == 'application/xml;charset=utf-8' }
      it("returns the correct body"){ expect(response.body).to be == 'application/xml' }
    end

    context "when sent '/' and HTTP_ACCEPT' => ''" do
      let(:response) { get '/', {}, {'HTTP_ACCEPT' => ''} }
      it("returns the correct content-type header"){ expect(response.header['Content-Type']).to be == 'application/xml;charset=utf-8' }
      it("returns the correct body"){ expect(response.body).to be == '' }
    end 

    context "when sent '/' and HTTP_ACCEPT' => '*/*'" do
      let(:response) { get '/', {}, {'HTTP_ACCEPT' => '*/*'} }
      it("returns the correct content-type header") { expect(response.header['Content-Type']).to be == 'application/xml;charset=utf-8' }
      it("returns the correct body") { expect(response.body).to be == '*/*' }
    end

    context "when sent '/' and HTTP_ACCEPT' => 'text/html;q=0.9'" do
      let(:response) { get '/', {}, {'HTTP_ACCEPT' => 'text/html;q=0.9'} }
      it("returns a 404") { expect(response.status).to be == 404 }
    end

    context "when sent '/foo' and HTTP_ACCEPT' => 'text/html;q=0.9'" do
      let(:response) { get '/foo', {}, {'HTTP_ACCEPT' => 'text/html;q=0.9'} }
      it("returns the correct body") { expect(response.body).to be == 'text/html;q=0.9' }
    end

    context "when sent '/foo' and HTTP_ACCEPT' => ''" do
      let(:response) { get '/foo', {}, {'HTTP_ACCEPT' => ''} }
      it("returns the correct body") { expect(response.body).to be == '' }
    end

    context "when sent '/foo' and HTTP_ACCEPT' => '*/*'" do
      let(:response) { get '/foo', {}, {'HTTP_ACCEPT' => '*/*'} }
      it("returns the correct body") { expect(response.body).to be == '*/*' }
    end

    context "when sent '/foo' and HTTP_ACCEPT' => 'application/xml'" do
      let(:response) { get '/foo', {}, {'HTTP_ACCEPT' => 'application/xml'} }
      it("returns a 404") { expect(response.status).to be == 404 }
    end
    
    context "when sent '/stream' and HTTP_ACCEPT' => 'text/event-stream'" do
      let(:response) { get '/stream', {}, {'HTTP_ACCEPT' => 'text/event-stream'} }
      it("returns the correct body") { expect(response.body).to be == 'text/event-stream' }
    end

    context "when sent '/stream' and HTTP_ACCEPT' => ''" do
      let(:response) { get '/stream', {}, {'HTTP_ACCEPT' => ''} }
      it("returns the correct body") { expect(response.body).to be == '' }
    end

    context "when sent '/stream' and HTTP_ACCEPT' => '*/*'" do
      let(:response) { get '/stream', {}, {'HTTP_ACCEPT' => '*/*'} }
      it("returns the correct body") { expect(response.body).to be == '*/*' }
    end

    context "when sent '/stream' and HTTP_ACCEPT' => 'application/xml'" do
      let(:response) { get '/stream', {}, {'HTTP_ACCEPT' => 'application/xml'} }
      it("returns a 404") { expect(response.status).to be == 404 }
    end

  end

  context 'filters by current content-type' do
    let(:app) do
      Sinatra.new do
        before('/txt') { content_type :txt }
        get('*', :provides => :txt) { 'txt' }
        before('/html') { content_type :html }
        get('*', :provides => :html) { 'html' }
      end
    end

    context "with '/' and HTTP_ACCEPT' => '*/*'" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => '*/*'} }
      it("returns correct Content-Type as text/plain;charset=utf-8"){ expect(response.header['Content-Type']).to be == 'text/plain;charset=utf-8' }
      it("returns correct body as txt"){ expect(response.body).to be == 'txt' }
    end

    context "with '/txt' and HTTP_ACCEPT' => 'text/plain'" do
      let(:response){ get '/txt', {}, {'HTTP_ACCEPT' => 'text/plain'} }
      it("returns correct Content-Type as text/plain;charset=utf-8"){ expect(response.header['Content-Type']).to be == 'text/plain;charset=utf-8' }
      it("returns correct body as txt"){ expect(response.body).to be == 'txt' }
    end

    context "with '/' and HTTP_ACCEPT' => 'text/html'" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'text/html'} }
      it("returns correct Content-Type as text/html;charset=utf-8"){ expect(response.header['Content-Type']).to be == 'text/html;charset=utf-8' }
      it("returns correct body as html"){ expect(response.body).to be == 'html' }
    end
  end

  context 'multiple content-types for accept header' do
    types = ['image/jpeg', 'image/pjpeg']
    let(:app) do
      Sinatra.new do
        get('/', :provides => types){ env['HTTP_ACCEPT'] }
      end
    end

    types.each do |type|
      context "allows #{type} as content-type" do
        let(:response){ get '/', {}, {'HTTP_ACCEPT' => type} }
        it("returns correct content_type"){ expect(response.header['Content-Type']).to be == type }
        it("returns correct body"){ expect(response.body).to be == type }
      end
    end
  end

  context 'respects user agent preferences for the content-type' do
    let(:app) do
      Sinatra.new do
        get('/', :provides => [:png, :html]){ content_type }
      end
    end

    context "when HTTP_ACCEPT = image/png;q=0.5,text/html;q=0.8" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'image/png;q=0.5,text/html;q=0.8'} }
      it("returns content-type:text/html"){ expect(response.body).to be == 'text/html;charset=utf-8' }
    end

    context "when HTTP_ACCEPT = image/png;q=0.8,text/html;q=0.5" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'image/png;q=0.8,text/html;q=0.5'} }
      it("returns content-type:image/png"){ expect(response.body).to be == 'image/png' }
    end
  end

  context 'accepts generic content-types' do
    let(:app) do
      Sinatra.new do
        get('/', :provides => :xml){ content_type }
        get('/'){'no match'}
      end
    end

    context "when HTTP_ACCEPT = 'foo/*'" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'foo/*'} }
      it("does not find a match"){ expect(response.body).to be == 'no match' }
    end

    context "when HTTP_ACCEPT = 'application/*'" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'application/*'} }
      it("returns correct content_type as application/xml"){ expect(response.body).to be == 'application/xml;charset=utf-8' }
    end

    context "when HTTP_ACCEPT = '*/*'" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => '*/*'} }
      it("returns correct content_type as application/xml"){ expect(response.body).to be == 'application/xml;charset=utf-8' }
    end
  end

  context 'prefers concrete over partly generic content-types' do
    let(:app) do
      Sinatra.new do
        get('/', :provides => [:png, :html]){ content_type }
      end
    end

    context "when HTTP_ACCEPT = image/*, text/html" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'image/*, text/html'} }
      it("prefers text/html"){ expect(response.body).to be == 'text/html;charset=utf-8' }
    end

    context "when HTTP_ACCEPT = image/png, text/*" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'image/png, text/*'} }
      it("prefers image/png"){ expect(response.body).to be == 'image/png' }
    end
  end

  context 'prefers concrete over fully generic content-types' do
    let(:app) do
      Sinatra.new do
        get('/', :provides => [:png, :html]){ content_type }
     end
    end

    context "when HTTP_ACCEPT = */*, text/html" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => '*/*, text/html'} }
      it("prefers text/html"){ expect(response.body).to be == 'text/html;charset=utf-8' }
    end
    
    context "when HTTP_ACCEPT = image/png, */*" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'image/png, */*'} }
      it("prefers image/png"){ expect(response.body).to be == 'image/png' }
    end
  end

  context 'prefers partly generic over fully generic content-types' do
    let(:app) do
      Sinatra.new do
        get('/', :provides => [:png, :html]){ content_type }
     end
    end

    context "when HTTP_ACCEPT = */*, text/*" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => '*/*, text/*'} }
      it("prefers text/html"){ expect(response.body).to be == 'text/html;charset=utf-8' }
    end

    context "when HTTP_ACCEPT = image/*, */*" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'image/*, */*'} }
      it("prefers image/png"){ expect(response.body).to be == 'image/png' }
    end
  end

  context 'respects quality with generic content-types' do
    let(:app) do
      Sinatra.new do
        get('/', :provides => [:png, :html]){ content_type }
     end
    end

    context "when HTTP_ACCEPT = image/*;q=1, text/html;q=0" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'image/*;q=1, text/html;q=0'} }
      it("prefers image/png"){ expect(response.body).to be == 'image/png' }
    end

    context "when HTTP_ACCEPT = image/png;q=0.5, text/*;q=0.7" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'image/png;q=0.5, text/*;q=0.7'} }
      it("prefers text/html"){ expect(response.body).to be == 'text/html;charset=utf-8' }
    end
  end

  context 'supplies the content-types with a default quality of 1.0' do
    let(:app) do
      Sinatra.new do
        get('/', :provides => [:png, :html]){ content_type }
     end
    end

    context "when HTTP_ACCEPT = image/png;q=0.5, text/*" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'image/png;q=0.5, text/*'} }
      it("prefers default q=1.0 setting of text/html"){ expect(response.body).to be == 'text/html;charset=utf-8' }
    end
  end

  context 'orders content-types with equal quality by parameter count' do
    let(:app) do
      Sinatra.new do
        get('/', :provides => [:png, :jpg]){ content_type }
      end
    end

    lo_png = 'image/png;q=0.5'
    hi_png = 'image/png;q=0.5;profile=FOGRA40;gamma=0.8'
    jpeg = 'image/jpeg;q=0.5;compress=0.25'

    context "when HTTP_ACCEPT = #{lo_png}, #{jpeg}" do
      let(:response){ get '/', {} , {'HTTP_ACCEPT' => "#{lo_png}, #{jpeg}"} }
      it("prefers image/jpeg"){ expect(response.body).to be == 'image/jpeg' }
    end

    context "when HTTP_ACCEPT = #{hi_png}, #{jpeg}" do
      let(:response){ get '/', {} , {'HTTP_ACCEPT' => "#{hi_png}, #{jpeg}"} }
      it("prefers image/png"){ expect(response.body).to be == 'image/png' }
    end
  end

  context 'ignores the quality parameter in content-types when ordering by parameter count' do
    let(:app) do
      Sinatra.new do
        get('/', :provides => [:png, :jpg]){ content_type }
      end
    end

    lo_png = 'image/png'
    hi_png = 'image/png;profile=FOGRA40;gamma=0.8'
    jpeg = 'image/jpeg;q=1.0;compress=0.25'

    context "when HTTP_ACCEPT = #{jpeg}, #{lo_png}" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => "#{jpeg}, #{lo_png}"} }
      it("prefers image/jpeg"){ expect(response.body).to be == 'image/jpeg' }
    end

    context "when HTTP_ACCEPT = #{jpeg}, #{hi_png}" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => "#{jpeg}, #{hi_png}"} }
      it("prefers image/png"){ expect(response.body).to be == 'image/png' }
    end
  end

#TODO what is 'profile' doing here? what are strings in params supposed to do? 
# Are they commented out? 

  context 'properly handles quoted strings in parameters' do
    let(:app) do
      Sinatra.new do
        get('/', :provides => [:png, :jpg]){ content_type }
      end
    end

    context "when HTTP_ACCEPT = image/png;q=0.5;profile=',image/jpeg,'" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'image/png;q=0.5;profile=",image/jpeg,"'} }
      it("the content_type is image/png"){ expect(response.body).to be == 'image/png' }
    end

    context "when HTTP_ACCEPT = image/png;q=0.5, image/jpeg;q=0;x=';q=1.0'" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'image/png;q=0.5, image/jpeg;q=0;x=";q=1.0"'} }
      it("the content-type is image/png"){ expect(response.body).to be == 'image/png' }
    end

    context "when HTTP_ACCEPT = image/png;q=0.5, image/jpeg;q=0;x='/\';q=1.0" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'image/png;q=0.5, image/jpeg;q=0;x="\";q=1.0"'} }
      it("the content-type is image/png"){ expect(response.body).to be == 'image/png' }
    end
  end

  context 'accepts both text/javascript and application/javascript for js' do
    let(:app) do
      Sinatra.new do
        get('/', :provides => :js){ content_type }
      end
    end
#TODO should we also be testing for when HTTP_ACCEPT is "text/javascript"?
    context "when HTTP_ACCEPT = text/javascript" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'text/javascript'} }
      it("the content-type is text/javascript"){ expect(response.body).to be == 'text/javascript;charset=utf-8' }
    end

    context "when HTTP_ACCEPT = application/javascript" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'application/javascript'} }
      it("the content-type is application/javascript"){ expect(response.body).to be == 'application/javascript;charset=utf-8' }
    end
  end

  context 'accepts both text/xml and application/xml for xml' do
    let(:app) do
      Sinatra.new do
        get('/', :provides => :xml){ content_type }
      end
    end

    context "when HTTP_ACCEPT = application/xml" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'application/xml'} }
      it("the content-type is application/xml"){ expect(response.body).to be == 'application/xml;charset=utf-8' }
    end

    context "when HTTP_ACCEPT = text/xml" do
      let(:response){ get '/', {}, {'HTTP_ACCEPT' => 'text/xml'} }
      it("the content-type is text/xml"){ expect(response.body).to be == 'text/xml;charset=utf-8' }
    end
  end

end