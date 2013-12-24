require File.join(File.dirname(__FILE__), '..', 'model', 'MetaData.rb')

describe MetaData do
	it "should get dirname" do
		expect(MetaData.new('hoge.ppt').dirname).to eq('hoge')
		expect(MetaData.new('hoge.tmp.ppt').dirname).to eq('hoge.tmp')
	end

	it "should get htmlPath" do
		expect(MetaData.new('hoge.ppt').htmlPath).to eq('hoge/hoge.html')
		expect(MetaData.new('hoge.tmp.ppt').htmlPath).to eq('hoge.tmp/hoge.tmp.html')
	end

	it "should get thumnailPath" do
		expect(MetaData.new('hoge.ppt').thumnailPath).to eq('hoge/png/page001.png')
		expect(MetaData.new('hoge.tmp.ppt').thumnailPath).to eq('hoge.tmp/png/page001.png')
	end

	it "should get pdfPath" do
		expect(MetaData.new('hoge.ppt').pdfPath).to eq('hoge/hoge.pdf')
		expect(MetaData.new('hoge.tmp.ppt').pdfPath).to eq('hoge.tmp/hoge.tmp.pdf')
	end

	it "should get relativePath" do
		expect(MetaData.new('hoge.ppt').relativePath).to eq('hoge/hoge.ppt')
		expect(MetaData.new('hoge.tmp.ppt').relativePath).to eq('hoge.tmp/hoge.tmp.ppt')
	end
end

