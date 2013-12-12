require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?
require 'haml'
require 'fileutils'

require './model/UploadedFile'

class PPTGallery < Sinatra::Base
	get '/' do
		redirect '/upload'
	end

	get '/upload' do
		Dir.mkdir('uploads') if !Dir.exists?('uploads')
		@resourceDirs = Dir.glob("uploads/*/").sort.reverse
		haml :upload
	end

	post "/upload" do
		ext = params['myfile'][:filename].split('.')[-1]
		uploadedFile = UploadedFile.new("#{Time.now.strftime('%Y%m%d%H%M%S')}_#{params['myfile'][:filename].split('.')[0]}.#{ext}")
		uploadedFile.save(params['myfile'][:tempfile])

		uploadedFile.savePdf()
		uploadedFile.savePng()
		uploadedFile.makeHtml()

		redirect '/upload'
	end

	post "/delete" do
		deleteUploaded(params['target'])
		redirect '/upload'
	end

	helpers do
		def deleteUploaded(path)
			FileUtils.rm_r(Dir.glob(path + '**/*.*'), {:force=>true})
			FileUtils.rm_r(Dir.glob(path + '**/'), {:force=>true})
		end
	end
end
