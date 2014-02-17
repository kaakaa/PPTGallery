require 'RMagick'
require 'haml'

class UploadedFile
	def initialize(root, home, m)
		@root = root
		@home = home
		@meta = m
		Dir.mkdir(@meta.dirname) if !Dir.exist?(@meta.dirname)
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
		engine = nil
		File.open(File.join(File.dirname(__FILE__), '..', 'views', 'slide.haml')) do |f|
			engine = Haml::Engine.new(f.read, :format => :xhtml).render(Object.new, :images => images, :title => @meta.filename)
		end
		File.write(File.join(@meta.dirname, "#{@meta.filename}.html"), engine) if !engine.nil?
	end

	def createMetaFile
		@meta.save()
	end
	
	def uploadedFilePath
		File.join(@meta.dirname, "#{@meta.filename}.#{@meta.ext}")
	end
end
