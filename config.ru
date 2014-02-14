require File.join(File.dirname(__FILE__), 'app.rb')
require File.join(File.dirname(__FILE__), 'lib', 'uploaded_file')
require File.join(File.dirname(__FILE__), 'lib', 'meta_data')
require File.join(File.dirname(__FILE__), 'lib', 'post')
require File.join(File.dirname(__FILE__), 'lib', 'my_logger')

map '/uploads' do
	run Rack::Directory.new('./uploads')
end

run Sinatra::Application
