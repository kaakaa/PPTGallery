xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
	xml.channel do
		xml.title "PPTGallery"
		xml.description "PPTGallery is PowerPoint slide uploader on CentOS"

		@posts.each do |post|
			xml.item do
				xml.title post.title
				xml.link post.link
				xml.description post.description
				xml.guid post.guid
			end
		end
	end
end
