require './app'

map '/uploads' do
	run Rack::Directory.new('./uploads')
end

run PPTGallery
