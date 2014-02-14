require 'json'

# filename
# ext
# created_at
# (tag)
# (comment)
class MetaData
	attr_accessor :filename, :ext, :created_at

	def initialize()
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

	def self.create(param)
		meta = MetaData.new
        	meta.filename = param.split('.')[0..-2].join('.')
        	meta.ext = param.split('.')[-1]
		meta.created_at = Time.now.strftime('%Y%m%d%H%M%S')
		meta
	end

	def save(homeDir)
		metaFile = File.join(homeDir, dirname, '.meta')
		File.open(metaFile, "w") do |f|
			JSON.dump({:filename => @filename, :ext => @ext, :created_at => @created_at}, f)
		end
	end

	def self.load(dirPath)
		metaFile = File.join(dirPath, '.meta')
		content = nil
		File.open(metaFile, 'r') do |f|
			content = JSON.load(f)
		end

		meta = MetaData.new
		meta.filename = content['filename']
		meta.ext = content['ext']
		meta.created_at = content["created_at"]
		meta
	end
end
