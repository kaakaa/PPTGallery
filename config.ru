require File.join(File.dirname(__FILE__), 'app.rb')
require File.join(File.dirname(__FILE__), 'model', 'UploadedFile.rb')
require File.join(File.dirname(__FILE__), 'model', 'Post.rb')

require File.join(File.dirname(__FILE__), 'lib', 'MyLogger.rb')

require 'logger'
class ::Logger; alias_method :write, :<<; end
logger = ::Logger.new('log/access.log', 'weekly')
use Rack::CommonLogger, logger

map '/uploads' do
	run Rack::Directory.new('./uploads')
end

run Sinatra::Application
