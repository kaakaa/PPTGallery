require 'RMagick'
require 'haml'

class UploadedFile
	def initialize(filename)
		@filename = filename
	end

	def save(tempFile)
		File.open(uploadedFilePath, "w") do |f|
			f.write(tempFile.read)
		end
	end

	def savePdf
		targetDirPath = "uploads/#{@filename.split('.')[0]}"
		Dir.mkdir(targetDirPath) if !Dir.exists?(targetDirPath)
		pdfPath = "#{targetDirPath}/#{@filename.split('_')[0]}.pdf"
		`java -jar javalib/jodconverter-cli-2.2.2.jar #{uploadedFilePath} #{pdfPath}`
	end

	def savePng
		targetDirPath = "uploads/#{@filename.split('.')[0]}"
		Dir.mkdir(targetDirPath) if !Dir.exists?(targetDirPath)
		Dir.mkdir("#{targetDirPath}/png")
		
		# make pdf file path
		# TODO extract method
		pdf = "uploads/#{@filename.split('.')[0]}/#{@filename.split('_')[0]}.pdf"
		pdf_magick = Magick::ImageList.new(pdf){ self.density = 150 }
		pdf_magick.each_with_index { |val, index|
			p "convering pdf to png (#{index+1}/#{pdf_magick.size})"
			pdf_magick[index].write("#{targetDirPath}/png/page#{format("%03d", index+1)}.png"){ self.quality = 100 }
		}
	end

	def makeHtml
		images = Dir.glob("uploads/#{@filename.split('.')[0]}/png/*.png").sort!
		engine = nil
		File.open("views/slide.haml") do |f|
			engine = Haml::Engine.new(f.read, :format => :xhtml).render(Object.new, :images => images)
		end
		File.write("uploads/#{@filename.split('.')[0]}/#{@filename.split('_')[0]}.html", engine) if !engine.nil?
	end
	
	def uploadedFilePath
		targetDirPath = "uploads/#{@filename.split('.')[0]}"
		Dir.mkdir(targetDirPath) if !Dir.exist?(targetDirPath)
		targetDirPath << '/' << @filename
	end
end
