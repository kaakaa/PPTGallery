require 'RMagick'
require 'haml'
require 'systemu'

class UploadedFile

	def initialize(dirname)
		@dirname = dirname
		@filename = @dirname.split('_')[1..-2].join('_')
	end

	def savePpt(uploadedFile)
		MyLogger.log.info "#{request.ip} : Start saving ppt in #{uploadedDirPath}"
		File.open(uploadedFilePath, "w") do |f|
			f.write(uploadedFile.read)
		end
		MyLogger.log.info "#{request.ip} : Finish saving ppt in #{uploadedDirPath}"
	end

	def savePdf
		MyLogger.log.info "#{request.ip} : Start converting to PDF in #{uploadedDirPath}"

		home = File.join(File.dirname(__FILE__), '..')
		pdfPath = File.join(uploadedDirPath, "#{@filename}.pdf")
		date = "java -jar #{home}/javalib/jodconverter-cli-2.2.2.jar #{uploadedFilePath} #{pdfPath}"
		status, stdout, stderr = systemu date
		if status.nil? then
			MyLogger.log.error "JODConverter is stopped by someone!"
		elsif status.exitstatus != 0 then
			MyLogger.log.error "Converting to PDF by JODConverter is failed."
			MyLogger.log.error "Exit Code: #{status}"
			MyLogger.log.error "STDOUT: #{stdout}"
			MyLogger.log.error "STERRT: #{stderr}"
		else
			MyLogger.log.info "Converting to PDF by JODConverter is success!"
			MyLogger.log.info "Exit Code: #{status}"
			MyLogger.log.info "STDOUT: #{stdout}"
			MyLogger.log.info "STERRT: #{stderr}"
		end

		MyLogger.log.info "#{request.ip} : Finish converting to PDF in #{uploadedDirPath}"
	end

	def savePng
		home = File.join(File.dirname(__FILE__), '..')
		Dir.mkdir(File.join(uploadedDirPath, "png"))
		
		MyLogger.log.info "#{request.ip} : Start converting to PNG in #{uploadedDirPath}"

		pdf = File.join(uploadedDirPath, "#{@filename}.pdf")
		pdf_magick = Magick::ImageList.new(pdf){ self.density = 150 }
		pdf_magick.each_with_index { |val, index|
			pdf_magick[index].write(File.join(uploadedDirPath, "png", "page#{format("%03d", index+1)}.png"))
		}

		MyLogger.log.info "#{request.ip} : Finish converting to PNG in #{uploadedDirPath}"

	end

	def makeHtml
		MyLogger.log.info "#{request.ip} : Start making HTML in #{uploadedDirPath}"

		home = File.join(File.dirname(__FILE__), '..')
		images = Array.new
		Dir.glob(File.join(uploadedDirPath, "png", "*.png")).sort!.each{ |d|
			images << d.gsub!(/#{home}/, '')
		}
		engine = nil
		File.open(File.join(home, "views", "slide.haml")) do |f|
			engine = Haml::Engine.new(f.read, :format => :xhtml).render(Object.new, :images => images)
		end
		File.write(File.join(uploadedDirPath, "#{@filename}.html"), engine) if !engine.nil?

		MyLogger.log.info "#{request.ip} : Finish making HTML in #{uploadedDirPath}"
	end
	
	def uploadedFilePath
		File.join(uploadedDirPath, "#{@filename}.#{@dirname.split('_')[-1]}")
	end

	def uploadedDirPath
		home = File.join(File.dirname(__FILE__), '..')
		targetDirPath = File.join(home, "uploads", @dirname)
		Dir.mkdir(targetDirPath) if !Dir.exist?(targetDirPath)
		targetDirPath
	end
end
