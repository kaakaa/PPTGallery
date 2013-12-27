require File.join(File.dirname(__FILE__), '..', 'model', 'MetaData.rb')

describe MetaData do
	it "should get dirname" do
		expect(MetaData.new('hoge.ppt').dirname).to match /\/uploads\/[0-9]{14}_hoge/
		expect(MetaData.new('hoge.tmp.ppt').dirname).to  match /\/uploads\/[0-9]{14}_hoge\.tmp/
	end

	it "should get htmlPath" do
		expect(MetaData.new('hoge.ppt').htmlPath).to match /\/uploads\/[0-9]{14}_hoge\/hoge\.html/
		expect(MetaData.new('hoge.tmp.ppt').htmlPath).to match /\/uploads\/[0-9]{14}_hoge.tmp\/hoge.tmp.html/
	end

	it "should get thumnailPath" do
		expect(MetaData.new('hoge.ppt').thumnailPath).to match /\/uploads\/[0-9]{14}_hoge\/png\/page001\.png/
		expect(MetaData.new('hoge.tmp.ppt').thumnailPath).to match /\/uploads\/[0-9]{14}_hoge\.tmp\/png\/page001\.png/
	end

	it "should get pdfPath" do
		expect(MetaData.new('hoge.ppt').pdfPath).to match /\/uploads\/[0-9]{14}_hoge\/hoge\.pdf/
		expect(MetaData.new('hoge.tmp.ppt').pdfPath).to match /\/uploads\/[0-9]{14}_hoge\.tmp\/hoge\.tmp\.pdf/
	end

	it "should get relativePath" do
		expect(MetaData.new('hoge.ppt').relativePath).to match /\/uploads\/[0-9]{14}_hoge\/hoge\.ppt/
		expect(MetaData.new('hoge.tmp.ppt').relativePath).to match /\/uploads\/[0-9]{14}_hoge\.tmp\/hoge\.tmp\.ppt/
	end
end

