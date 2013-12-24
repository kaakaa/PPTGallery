require 'json'

# filename
# ext
# created_at
# (tag)
# (comment)
class MetaData
	def initialize(param)
        	@filename = param.split('.')[0..-2].join('.')
        	@ext = param.split('.')[-1]
		@created_at = Time.now.strftime('%Y%m%d%H%M%S')
	end

	def relativePath
		return "#{@filename}/#{@filename}.#{@ext}"
	end
end
