require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require 'haml'
require 'fileutils'
require 'builder'
require 'logger'
require 'eventmachine'

require File.expand_path('helpers', File.dirname(__FILE__))
require File.expand_path('slide', File.dirname(__FILE__))
require File.expand_path('meta_data', File.dirname(__FILE__))
require File.expand_path('post', File.dirname(__FILE__))
require File.expand_path('my_logger', File.dirname(__FILE__))

module PPTGallery
  class App < Sinatra::Base
    set :public_folder, File.expand_path('../../public', File.dirname(__FILE__))
    set :views, File.expand_path('../../views', File.dirname(__FILE__))
    set :protection, :except => :frame_options
    set :method_override => true
    set :bind, '0.0.0.0'

    configure do
      enable :logging
      mime_type :svg, 'image/svg+xml'
      mime_type :svgz, 'image/svg+xml'
    end

    before do
      @uploadDir = File.join(settings.public_folder, 'uploads')
      Dir.mkdir(@uploadDir) if !Dir.exists?(@uploadDir)
    end

    get '/' do
      redirect '/gallery/1'
    end

    get '/gallery/:page' do
      MyLogger.log.info "#{request.ip} : Access in page #{params[:page]}"
      @current = params[:page].to_i
      @metaDataArray, @pagenum = getMetaDataForDisplay(@uploadDir, @current)
      haml :main
    end

    get '/log' do
      logs = File.expand_path('../../log/application.log', File.dirname(__FILE__))
      log = File.open(logs).read if File.exists?(logs)

      content_type 'text/plain'
      log.split("\n").reverse.join("\n")
    end

    post "/upload" do
      # uplod dir name is "#{Datetime}_#{UploadedFilename}"
      MyLogger.log.info "#{request.ip} : Upload file #{params['myfile'][:filename]}"
      meta = MetaData.create(settings.public_folder, params['myfile'][:filename])

      upload = proc do
        begin
          Dir.mkdir(meta.dirname) if !Dir.exist?(meta.dirname)
          meta.save

          MyLogger.log.info "#{request.ip} : Start converting #{meta.relativePath}"
          Slide.new(settings, meta).upload(request.ip, params['myfile'][:tempfile])
        rescue => ex
          MyLogger.log.error "#{request.ip} : Failing Upload to #{meta.filename}"
          MyLogger.log.error "#{request.ip} : #{ex.message}"
          deleteUploaded(meta.dirname)
        end
      end
      callback = proc do |c|
        # meta.save()
      end
      EM.defer(upload, callback)

      redirect '/gallery/1'
    end

    get '/rss' do
      dirs = Dir.glob(File.join(@uploadDir, "*")).sort.reverse
      @posts = []
      @lastBuildDate = DateTime.parse('2000/1/1')
      dirs[0..15].each{ |d|
        post = Post.new(d.gsub!(/#{settings.public_folder}/,''), "#{request.host}:#{request.port}")
        @posts << post
        @lastBuildDate = post.pubDate if @lastBuildDate < post.pubDate
      }
      builder :rss
    end

    delete "/delete" do
      MyLogger.log.info "#{request.ip} : Deleting #{params['target']}"
      deleteUploaded(params['target'])
      MyLogger.log.info "#{request.ip} : Complete deleting #{params['target']}"
      redirect '/gallery/1'
    end

    helpers do
      include Helpers
    end
  end
end
