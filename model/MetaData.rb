require 'json'

# filename
# ext
# created_at
# (tag)
# (comment)
class MetaData
	attr_accessor :filename, :ext, :created_at

	def initialize(param)
        	@filename = param.split('.')[0..-2].join('.')
        	@ext = param.split('.')[-1]
		@created_at = Time.now.strftime('%Y%m%d%H%M%S')
		@resourceDir = '/uploads'
	end

	def dirname
		"#{@resourceDir}/#{@created_at}_#{@filename}"
	end

	def htmlPath
		"#{dirname}/#{@filename}.html"
	end

	def thumnailPath
		"#{dirname}/png/page001.png"
	end

	def pdfPath
		"#{dirname}/#{@filename}.pdf"
	end

	def relativePath
		"#{dirname}/#{@filename}.#{@ext}"
	end

	def save(homeDir)
		metaFile = File.join(homeDir, dirname, '.meta')
		open(metaFile, "w") do |f|
			JSON.dump({:filename => @filename, :ext => @ext, :created_at => @created_at}, f)
		end
	end

	def self.load(dirname)
		MetaData.new('currietesting.ppt')
	end
end
