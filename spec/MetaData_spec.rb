require File.join(File.dirname(__FILE__), '..', 'model', 'MetaData.rb')

describe MetaData do
	it "should get relativePath" do
		expect(MetaData.new('hoge.ppt').relativePath).to eq('hoge/hoge.ppt')
		expect(MetaData.new('hoge.tmp.ppt').relativePath).to eq('hoge.tmp/hoge.tmp.ppt')
	end
end

