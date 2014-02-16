require 'RMagick'
require 'haml'
require 'systemu'

class UploadedFile
	def initialize(root, home, m)
		@root = root
		@home = home
		@meta = m
	end

	def saveUploaded(uploadedFile)
		File.open(uploadedFilePath, "w") do |f|
			f.write(uploadedFile.read)
		end
	end

	def savePdf
		if @meta.ext == 'pdf'
			return
		end

		pdfPath = File.join(uploadedDirPath, "#{@meta.filename}.pdf")
		date = "java -jar #{File.dirname(__FILE__)}/javalib/jodconverter-cli-2.2.2.jar #{uploadedFilePath} #{pdfPath}"
		status, stdout, stderr = systemu date

		if status.nil? then
			MyLogger.log.error "JODConverter is stopped by someone!"
			return
		elsif status.exitstatus != 0 then
			MyLogger.log.error "Converting to PDF by JODConverter is failed."
		else
			MyLogger.log.info "Converting to PDF by JODConverter is success!"
		end
		MyLogger.log.info "Exit Code: #{status}"
		MyLogger.log.info "STDOUT: #{stdout}"
		MyLogger.log.info "STERRT: #{stderr}"
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
		File.open(File.join(File.dirname(__FILE__), '..', 'views', 'slide.haml')) do |f|
			engine = Haml::Engine.new(f.read, :format => :xhtml).render(Object.new, :images => images, :title => @meta.filename)
		end
		File.write(File.join(uploadedDirPath, "#{@meta.filename}.html"), engine) if !engine.nil?
	end

	def createMetaFile
		@meta.save()
	end
	
	def uploadedFilePath
		File.join(uploadedDirPath, "#{@meta.filename}.#{@meta.ext}")
	end

	def uploadedDirPath
		targetDirPath = File.join(@meta.dirname)
		Dir.mkdir(targetDirPath) if !Dir.exist?(targetDirPath)
		targetDirPath
	end
end
