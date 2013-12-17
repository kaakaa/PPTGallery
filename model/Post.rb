class Post
	attr_accessor :title, :link, :description, :guid

	def initialize(dirname, url)
		@title = dirname.split('/')[-1].split('_')[1..-2].join('_')
		@link = "http://#{url}"
		@guid = "http://#{url}#{dirname}#{dirname.split('/')[-1].split('_')[1..-2].join('_')}.html"
		@description = "uploaded slide"
	end
end
