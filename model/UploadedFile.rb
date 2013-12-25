require 'RMagick'
require 'haml'
require 'systemu'

class UploadedFile

	def initialize(m)
		@meta = m
		@home = File.join(File.dirname(__FILE__), '..')
	end

	def savePpt(uploadedFile)
		File.open(uploadedFilePath, "w") do |f|
			f.write(uploadedFile.read)
		end
	end

	def savePdf
		pdfPath = File.join(uploadedDirPath, "#{@meta.filename}.pdf")
		date = "java -jar #{@home}/javalib/jodconverter-cli-2.2.2.jar #{uploadedFilePath} #{pdfPath}"
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
	end

	def savePng
		Dir.mkdir(File.join(uploadedDirPath, "png"))
		pdf = File.join(uploadedDirPath, "#{@meta.filename}.pdf")
		pdf_magick = Magick::ImageList.new(pdf){ self.density = 150 }
		pdf_magick.each_with_index { |val, index|
			pdf_magick[index].write(File.join(uploadedDirPath, "png", "page#{format("%03d", index+1)}.png"))
		}
	end

	def makeHtml
		images = Array.new
		Dir.glob(File.join(uploadedDirPath, "png", "*.png")).sort!.each{ |d|
			images << d.gsub!(/#{@home}/, '')
		}
		engine = nil
		File.open(File.join(@home, "views", "slide.haml")) do |f|
			engine = Haml::Engine.new(f.read, :format => :xhtml).render(Object.new, :images => images)
		end
		File.write(File.join(uploadedDirPath, "#{@meta.filename}.html"), engine) if !engine.nil?
	end

	def createMetaFile
		@meta.save(@home)
	end
	
	def uploadedFilePath
		File.join(uploadedDirPath, "#{@meta.filename}.#{@meta.ext}")
	end

	def uploadedDirPath
		targetDirPath = File.join(@home, @meta.dirname)
		Dir.mkdir(targetDirPath) if !Dir.exist?(targetDirPath)
		targetDirPath
	end
end
