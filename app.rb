require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require 'haml'
require 'fileutils'
require 'builder'
require 'logger'

configure do
	enable :logging
end

get '/' do
	redirect '/gallery/1'
end

get '/gallery/:page' do
	MyLogger.log.info "#{request.ip} : Access in page #{params[:page]}"
	home = File.dirname(__FILE__)
	Dir.mkdir(File.join(home, 'uploads')) if !Dir.exists?(File.join(home, 'uploads'))
	dirs = Dir.glob(File.join(home, "uploads","*")).sort.reverse
	@resourceDirs = Array.new
	page = params[:page].to_i
	dirs[(page-1)*15..page*15-1].each{ |d|
		@resourceDirs << "#{d.gsub!(/#{home}/,'')}/"
	}
	@pagenum = dirs.size() % 15 == 0? dirs.size() / 15 : (dirs.size() / 15) + 1
	@current = params[:page].to_i
	haml :upload
end

post "/upload" do
	# uplod dir name is "#{Datetime}_#{UploadedFilename}_#{ext}"
	MyLogger.log.info "#{request.ip} : Upload file #{params['myfile'][:filename]}"
	ext = params['myfile'][:filename].split('.')[-1]
	filename = params['myfile'][:filename].split('.')[0]
	dirname = "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{filename}_#{ext}"

	begin
		MyLogger.log.info "#{request.ip} : Start converting #{dirname}/#{params['myfile'][:filename]}"
		uploadedFile = UploadedFile.new(dirname)
		uploadedFile.savePpt(params['myfile'][:tempfile])
		MyLogger.log.info "#{request.ip} : #{params['myfile'][:filename]} saved."
		uploadedFile.savePdf()
		MyLogger.log.info "#{request.ip} : Complete converting to PDF."
		uploadedFile.savePng()
		MyLogger.log.info "#{request.ip} : Complete converting to PNG."
		uploadedFile.makeHtml()
		MyLogger.log.info "#{request.ip} : Complete making HTML."
		MyLogger.log.info "#{request.ip} : Complete uploading."
	rescue
		MyLogger.log.error "#{request.ip} : Failing Upload to #{dirname}/#{params['myfile'][:filename]}"
		deleteUploaded(dirname)
	end
	redirect '/gallery/1'
end

get '/rss' do
	home = File.dirname(__FILE__)
	dirs = Dir.glob(File.join(home, "uploads","*")).sort.reverse
	@posts = []
	dirs[0..15].each{ |d|
		@posts << Post.new(d.gsub!(/#{home}/,''), "#{request.host}:#{request.port}")
	}
	@lastBuildDate = DateTime.parse('2000/1/1')
	@posts.each{ |p|
		@lastBuildDate = p.pubDate if  @lastBuildDate < p.pubDate
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
	def deleteUploaded(path)
		FileUtils.rm_r(Dir.glob(File.join(File.dirname(__FILE__), path, "**", "*.*")), {:force=>true})
		FileUtils.rm_r(Dir.glob(File.join(File.dirname(__FILE__), path)), {:force=>true})
	end
end
