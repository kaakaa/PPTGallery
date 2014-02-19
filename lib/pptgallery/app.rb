require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require 'haml'
require 'fileutils'
require 'builder'
require 'logger'

require File.join(File.dirname(__FILE__), 'helpers')
require File.join(File.dirname(__FILE__), 'uploaded_file')
require File.join(File.dirname(__FILE__), 'meta_data')
require File.join(File.dirname(__FILE__), 'post')
require File.join(File.dirname(__FILE__), 'my_logger')
require File.join(File.dirname(__FILE__), 'cmd_executor')

module PPTGallery
	class App < Sinatra::Base
		set :public_folder, File.expand_path('../../public', File.dirname(__FILE__))
		set :views, File.expand_path('../../views', File.dirname(__FILE__))
		set :protection, :except => :frame_options
		set :method_override => true

		configure do
			enable :logging
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
			haml :upload
		end

		post "/upload" do
			# uplod dir name is "#{Datetime}_#{UploadedFilename}"
			MyLogger.log.info "#{request.ip} : Upload file #{params['myfile'][:filename]}"
        		meta = MetaData.create(settings.public_folder, params['myfile'][:filename])

			begin
				MyLogger.log.info "#{request.ip} : Start converting #{meta.relativePath}"
				uploadedFile = UploadedFile.new(settings.root, settings.public_folder, meta)
				uploadedFile.convert(request.ip, params['myfile'][:tempfile])
			rescue => ex
				MyLogger.log.error "#{request.ip} : Failing Upload to #{meta.filename}"
				MyLogger.log.error "#{request.ip} : #{ex.message}"
				deleteUploaded(meta.dirname)
			end
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
