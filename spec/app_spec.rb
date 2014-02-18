require 'spec_helper'
require File.expand_path('../lib/pptgallery/my_logger', File.dirname(__FILE__))
require File.expand_path('../lib/pptgallery/uploaded_file', File.dirname(__FILE__))
require File.expand_path('../lib/pptgallery/post', File.dirname(__FILE__))
require File.expand_path('../lib/pptgallery/meta_data', File.dirname(__FILE__))
require File.expand_path('../lib/pptgallery/cmd_executor', File.dirname(__FILE__))

# set :root, File.dirname(__FILE__)
# set :public_folder, File.dirname(__FILE__)

describe PPTGallery::App do

	before :all do
		app.set(:root, File.dirname(__FILE__))
		app.set(:public_folder, File.dirname(__FILE__))
		Dir.mkdir(upload_path) if !Dir.exists?(upload_path)
	end

	after :each do
		clear_all
	end

	it 'can upload and convert ppt file' do
		post '/upload', 'myfile' => Rack::Test::UploadedFile.new(File.join(fixture_path, 'sample.ppt'), 'application/ppt')
		expect(last_response).to be_redirect
		expect(last_response.location).to eq('http://example.org/gallery/1')

		expect(Dir.glob(File.join(upload_path, '*')).count).to eq(1)
		expect(Dir.glob(File.join(upload_path, '**/.meta')).count).to eq(1)
		expect(Dir.glob(File.join(upload_path, '**/sample.ppt')).count).to eq(1)
		expect(Dir.glob(File.join(upload_path, '**/sample.pdf')).count).to eq(1)
		expect(Dir.glob(File.join(upload_path, '**/sample.html')).count).to eq(1)
		expect(Dir.glob(File.join(upload_path, '**/png/page*.png')).count).to eq(8)
	end

	it 'can upload and convert pdf file' do
		post '/upload', 'myfile' => Rack::Test::UploadedFile.new(File.join(fixture_path, 'sample.pdf'), 'application/pdf')
		expect(last_response).to be_redirect
		expect(last_response.location).to eq('http://example.org/gallery/1')

		expect(Dir.glob(File.join(upload_path, '*')).count).to eq(1)
		expect(Dir.glob(File.join(upload_path, '**/.meta')).count).to eq(1)
		expect(Dir.glob(File.join(upload_path, '**/sample.ppt')).count).to eq(0)
		expect(Dir.glob(File.join(upload_path, '**/sample.pdf')).count).to eq(1)
		expect(Dir.glob(File.join(upload_path, '**/sample.html')).count).to eq(1)
		expect(Dir.glob(File.join(upload_path, '**/png/page*.png')).count).to eq(8)
	end
end
