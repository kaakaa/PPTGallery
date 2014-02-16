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
	uploadDir = File.join(settings.public_folder, 'uploads')
	@current = page = params[:page].to_i
	Dir.mkdir(uploadDir) if !Dir.exists?(uploadDir)
	@metaDataArray, @pagenum = getMetaDataForDisplay(uploadDir, @current)
	haml :upload
end

post "/upload" do
	# uplod dir name is "#{Datetime}_#{UploadedFilename}"
	MyLogger.log.info "#{request.ip} : Upload file #{params['myfile'][:filename]}"
        meta = MetaData.create(settings.public_folder, params['myfile'][:filename])
	ext = params['myfile'][:filename].split('.')[-1]
	filename = params['myfile'][:filename].split('.')[0]
	dirname = "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{filename}_#{ext}"

	begin
		MyLogger.log.info "#{request.ip} : Start converting #{meta.relativePath}"
		uploadedFile = UploadedFile.new(settings.root, settings.public_folder, meta)
		uploadedFile.saveUploaded(params['myfile'][:tempfile])
		MyLogger.log.info "#{request.ip} : #{meta.filename} saved."
		uploadedFile.savePdf()
		MyLogger.log.info "#{request.ip} : Complete converting to PDF."
		uploadedFile.savePng()
		MyLogger.log.info "#{request.ip} : Complete converting to PNG."
		uploadedFile.makeHtml()
		MyLogger.log.info "#{request.ip} : Complete making HTML."
		uploadedFile.createMetaFile()
		MyLogger.log.info "#{request.ip} : Complete creating .meta."
		MyLogger.log.info "#{request.ip} : Complete uploading."
	rescue => ex
		MyLogger.log.error "#{request.ip} : Failing Upload to #{meta.filename}"
		MyLogger.log.error "#{request.ip} : #{ex.message}"
		deleteUploaded(dirname)
	end
	redirect '/gallery/1'
end

get '/rss' do
	home = settings.public_folder
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
	p params['target']
	deleteUploaded(params['target'])
	MyLogger.log.info "#{request.ip} : Complete deleting #{params['target']}"
	redirect '/gallery/1'
end

helpers do
	def deleteUploaded(path)
		FileUtils.rm_r(Dir.glob(File.join(File.dirname(__FILE__), path, "**", "*.*")), {:force=>true})
		FileUtils.rm_r(Dir.glob(File.join(File.dirname(__FILE__), path)), {:force=>true})
	end

	def getMetaDataForDisplay(dirname, page)
 		dirs = Dir.glob("#{dirname}/*/").sort.reverse
                metaDataArray = Array.new
                dirs[(page-1)*15..page*15-1].each{ |d|
                        metaDataArray << MetaData.load(settings.public_folder, d)
                }
		pagenum = dirs.size() % 15 == 0? dirs.size() / 15 : (dirs.size() / 15) + 1
		return metaDataArray, pagenum
	end
end
