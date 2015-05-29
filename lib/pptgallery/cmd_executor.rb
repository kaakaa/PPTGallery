require 'systemu'
require 'libreconv'

class CommandExecutor
	def self.jodconverter(uploadedFilePath, pdfPath)
		date = "java -jar #{File.dirname(__FILE__)}/javalib/jodconverter-cli-2.2.2.jar #{uploadedFilePath} #{pdfPath}"
		status, stdout, stderr = systemu date

		if status.nil? then
			MyLogger.log.error "JODConverter is stopped by someone!"
			raise InternalError.new("JODConverter abnormally end.")
		elsif status.exitstatus != 0 then
			MyLogger.log.error "Converting to PDF by JODConverter is failed."
		end

		MyLogger.log.info "Converting to PDF by JODConverter is success!"
		MyLogger.log.info "Exit Code: #{status}"
		MyLogger.log.info "STDOUT: #{stdout}"
		MyLogger.log.info "STERRT: #{stderr}"
	end

	def self.convert(inputPath, outputPath)
		Libreconv.convert(inputPath,outputPath)
	end
end
