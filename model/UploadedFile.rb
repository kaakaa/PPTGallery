require 'RMagick'
require 'haml'

class UploadedFile

	def initialize(dirname)
		@dirname = dirname
		@filename = @dirname.split('_')[1..-2].join('_')
	end

	def savePpt(uploadedFile)
		File.open(uploadedFilePath, "w") do |f|
			f.write(uploadedFile.read)
		end
	end

	def savePdf
		home = File.join(File.dirname(__FILE__), '..')
		pdfPath = File.join(uploadedDirPath, "#{@filename}.pdf")
                p uploadedFilePath
		`java -jar #{home}/javalib/jodconverter-cli-2.2.2.jar #{uploadedFilePath} #{pdfPath}`
	end

	def savePng
		home = File.join(File.dirname(__FILE__), '..')
		Dir.mkdir(File.join(uploadedDirPath, "png"))
		
		# make pdf file path
		# TODO extract method
		pdf = File.join(uploadedDirPath, "#{@filename}.pdf")
		pdf_magick = Magick::ImageList.new(pdf){ self.density = 150 }
		pdf_magick.each_with_index { |val, index|
			pdf_magick[index].write(File.join(uploadedDirPath, "png", "page#{format("%03d", index+1)}.png"))
		}
	end

	def makeHtml
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
