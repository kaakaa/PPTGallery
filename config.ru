$LOAD_PATH.unshift(::File.expand_path('lib', ::File.dirname(__FILE__)))

# require File.join(File.dirname(__FILE__), 'app')
# require File.join(File.dirname(__FILE__), 'lib', 'uploaded_file')
# require File.join(File.dirname(__FILE__), 'lib', 'meta_data')
# require File.join(File.dirname(__FILE__), 'lib', 'post')
# require File.join(File.dirname(__FILE__), 'lib', 'my_logger')
# require File.join(File.dirname(__FILE__), 'lib', 'cmd_executor')

require 'pptgallery/app'

# run Sinatra::Application
run PPTGallery::App
