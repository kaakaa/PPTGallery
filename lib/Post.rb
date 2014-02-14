class Post
	attr_accessor :title, :link, :description, :guid, :pubDate

	def initialize(dirname, url)
		@title = dirname.split('/')[-1].split('_')[1..-2].join('_')
		@link = "http://#{url}"
		@guid = "http://#{url}#{dirname}/#{dirname.split('/')[-1].split('_')[1..-2].join('_')}.html"
		@description = "uploaded slide"
		@pubDate = DateTime.strptime(dirname.split('/')[-1].split('_')[0], "%Y%m%d%H%M%S").new_offset(Rational(-9,24))
	end
end
