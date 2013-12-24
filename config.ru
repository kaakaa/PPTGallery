require File.join(File.dirname(__FILE__), 'app.rb')
require File.join(File.dirname(__FILE__), 'model', 'UploadedFile.rb')
require File.join(File.dirname(__FILE__), 'model', 'MetaData.rb')
require File.join(File.dirname(__FILE__), 'model', 'Post.rb')

require File.join(File.dirname(__FILE__), 'lib', 'MyLogger.rb')

map '/uploads' do
	run Rack::Directory.new('./uploads')
end

run Sinatra::Application
