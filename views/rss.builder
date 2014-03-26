xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
	xml.channel do
		xml.title "PPTGallery"
		xml.description "PPTGallery is PowerPoint slide uploader on CentOS"
		xml.link @posts[0].link
		xml.language "ja-JP"
		xml.pubDate @lastBuildDate.strftime("%a, %d %b %Y %X %Z")
		xml.lastBuildDate @lastBuildDate.strftime("%a, %d %b %Y %X %Z")
		@posts.each do |post|
			xml.item do
				xml.title post.title
				xml.link post.link
				xml.description post.description
				xml.guid post.guid
				xml.pubDate post.pubDate.strftime("%a, %d %b %Y %X %Z")
			end
		end
	end
end
