require 'RMagick'
require 'haml'

require File.expand_path('cmd_executor', File.dirname(__FILE__))

class UploadedFile
	def initialize(root, home, m)
		@root = root
		@home = home
		@meta = m
		Dir.mkdir(@meta.dirname) if !Dir.exist?(@meta.dirname)
	end

	def convert(ip, tempfile)
		saveUploaded(tempfile)
		MyLogger.log.info "#{ip} : #{@meta.filename} saved."

		savePdf()
		MyLogger.log.info "#{ip} : Complete converting to PDF."

		savePng()
		MyLogger.log.info "#{ip} : Complete converting to PNG."

		makeHtml()
		MyLogger.log.info "#{ip} : Complete making HTML."

		createMetaFile()
		MyLogger.log.info "#{ip} : Complete creating .meta."
		MyLogger.log.info "#{ip} : Complete uploading."
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
		pdfPath = File.join(@meta.dirname, "#{@meta.filename}.pdf")
		CommandExecutor.jodconverter(uploadedFilePath, pdfPath)
	end

	def savePng
		Dir.mkdir(File.join(@meta.dirname, "png"))
		pdf = File.join(@meta.dirname, "#{@meta.filename}.pdf")
		pdf_magick = Magick::ImageList.new(pdf){ self.density = 150 }
		pdf_magick.each_with_index { |val, index|
			pdf_magick[index].write(File.join(@meta.dirname, "png", "page#{format("%03d", index+1)}.png"))
		}
	end

	def makeHtml
		images = Array.new
		Dir.glob(File.join(@meta.dirname, "png", "*.png")).sort!.each{ |d|
			images << d.gsub!(/#{@home}/, '')
		}
		source = partial('slide.haml', {:images => images, :title => @meta.filename})
		File.write(File.join(@meta.dirname, "#{@meta.filename}.html"), source) if !source.nil?
	end

	def createMetaFile
		@meta.save()
	end
	
	def uploadedFilePath
		File.join(@meta.dirname, "#{@meta.filename}.#{@meta.ext}")
	end

	def partial(filename, options={})
		contents = File.read(File.expand_path("templates/#{filename}", File.dirname(__FILE__)))
		Haml::Engine.new(contents).render(self, options.merge!(:layout => false))
	end
end
