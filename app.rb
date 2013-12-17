require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require 'haml'
require 'fileutils'
require 'builder'

get '/' do
	redirect '/gallery/1'
end

get '/gallery/:page' do
	home = File.dirname(__FILE__)
	Dir.mkdir(File.join(home, 'uploads')) if !Dir.exists?(File.join(home, 'uploads'))
	dirs = Dir.glob(File.join(home, "uploads","*")).sort.reverse
	@resourceDirs = Array.new
	page = params[:page].to_i
	dirs[(page-1)*15..page*15-1].each{ |d|
		@resourceDirs << "#{d.gsub!(/#{home}/,'')}/"
	}
	@pagenum = (dirs.size() / 15) + 1
	@current = params[:page].to_i
	haml :upload
end

post "/upload" do
	# uplod dir name is "#{Datetime}_#{UploadedFilename}_#{ext}"
	ext = params['myfile'][:filename].split('.')[-1]
	filename = params['myfile'][:filename].split('.')[0]
	dirname = "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{filename}_#{ext}"

	uploadedFile = UploadedFile.new(dirname)
	uploadedFile.savePpt(params['myfile'][:tempfile])

	uploadedFile.savePdf()
	uploadedFile.savePng()
	uploadedFile.makeHtml()

	redirect '/upload'
end

get '/rss' do
	home = File.dirname(__FILE__)
	dirs = Dir.glob(File.join(home, "uploads","*")).sort.reverse
	@posts = []
	dirs[0..15].each{ |d|
		@posts << Post.new(d.gsub!(/#{home}/,''), "#{request.host}:#{request.port}")
	}
	builder :rss
end

post "/delete" do
	deleteUploaded(params['target'])
	redirect '/upload'
end

delete "/delete" do
	deleteUploaded(params['target'])
	redirect '/upload'
end
helpers do
	def deleteUploaded(path)
		FileUtils.rm_r(Dir.glob(File.join(File.dirname(__FILE__), path, "**", "*.*")), {:force=>true})
		FileUtils.rm_r(Dir.glob(File.join(File.dirname(__FILE__), path)), {:force=>true})
	end
end
