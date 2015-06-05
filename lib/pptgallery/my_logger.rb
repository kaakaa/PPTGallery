require 'logger'

module MyLogger extend self
  attr_accessor :log

  self.log = Logger.new('application.log')
  self.log.level = Logger::DEBUG
  self.log.formatter = proc { |severity, datetime, progname, msg|
    "#{severity} : #{datetime.strftime('%Y-%m-%d %H:%M:%S')} :: #{msg}\n"
  }
end
