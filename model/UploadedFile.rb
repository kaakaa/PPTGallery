require 'RMagick'
require 'haml'

class UploadedFile

	def initialize(filename)
		p filename
		@filename = filename
	end

	def save(tempFile)
		File.open(uploadedFilePath, "w") do |f|
			f.write(tempFile.read)
		end
	end

	def savePdf
		home = File.join(File.dirname(__FILE__), '..')
		targetDirPath = File.join(home, "uploads", "#{@filename.split('.')[0]}")
		Dir.mkdir(targetDirPath) if !Dir.exists?(targetDirPath)
		pdfPath = "#{targetDirPath}/#{@filename.split('_')[1]}.pdf"
		`java -jar #{home}/javalib/jodconverter-cli-2.2.2.jar #{uploadedFilePath} #{pdfPath}`
	end

	def savePng
		home = File.join(File.dirname(__FILE__), '..')
		targetDirPath = File.join(home, "uploads", "#{@filename.split('.')[0]}")
		Dir.mkdir(targetDirPath) if !Dir.exists?(targetDirPath)
		Dir.mkdir(File.join(targetDirPath, "png"))
		
		# make pdf file path
		# TODO extract method
		pdf = File.join(home, "uploads", "#{@filename.split('.')[0]}", "#{@filename.split('_')[1]}.pdf")
		pdf_magick = Magick::ImageList.new(pdf){ self.density = 150 }
		pdf_magick.each_with_index { |val, index|
			p "convering pdf to png (#{index+1}/#{pdf_magick.size})"
			pdf_magick[index].write(File.join(targetDirPath, "png", "page#{format("%03d", index+1)}.png")){ self.quality = 100 }
		}
	end

	def makeHtml
		home = File.join(File.dirname(__FILE__), '..')
		images = Array.new
		 Dir.glob(File.join(home, "uploads", "#{@filename.split('.')[0]}", "png", "*.png")).sort!.each{ |d|
			images << d.gsub!(/#{home}/, '')
		}
		engine = nil
		File.open(File.join(home, "views", "slide.haml")) do |f|
			engine = Haml::Engine.new(f.read, :format => :xhtml).render(Object.new, :images => images)
		end
		File.write(File.join(home, "uploads", "#{@filename.split('.')[0]}", "#{@filename.split('_')[1]}.html"), engine) if !engine.nil?
	end
	
	def uploadedFilePath
		home = File.join(File.dirname(__FILE__), '..')
		targetDirPath = File.join(home, "uploads", "#{@filename.split('.')[0]}")
		Dir.mkdir(targetDirPath) if !Dir.exist?(targetDirPath)
		targetDirPath << '/' << @filename
	end
end
