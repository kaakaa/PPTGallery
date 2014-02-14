require File.join(File.dirname(__FILE__), '..', 'lib', 'meta_data')

describe MetaData do
	it "should get dirname" do
		expect(MetaData.create('hoge.ppt').dirname).to match /\/uploads\/[0-9]{14}_hoge/
		expect(MetaData.create('hoge.tmp.ppt').dirname).to  match /\/uploads\/[0-9]{14}_hoge\.tmp/
	end

	it "should get htmlPath" do
		expect(MetaData.create('hoge.ppt').htmlPath).to match /\/uploads\/[0-9]{14}_hoge\/hoge\.html/
		expect(MetaData.create('hoge.tmp.ppt').htmlPath).to match /\/uploads\/[0-9]{14}_hoge.tmp\/hoge.tmp.html/
	end

	it "should get thumnailPath" do
		expect(MetaData.create('hoge.ppt').thumnailPath).to match /\/uploads\/[0-9]{14}_hoge\/png\/page001\.png/
		expect(MetaData.create('hoge.tmp.ppt').thumnailPath).to match /\/uploads\/[0-9]{14}_hoge\.tmp\/png\/page001\.png/
	end

	it "should get pdfPath" do
		expect(MetaData.create('hoge.ppt').pdfPath).to match /\/uploads\/[0-9]{14}_hoge\/hoge\.pdf/
		expect(MetaData.create('hoge.tmp.ppt').pdfPath).to match /\/uploads\/[0-9]{14}_hoge\.tmp\/hoge\.tmp\.pdf/
	end

	it "should get relativePath" do
		expect(MetaData.create('hoge.ppt').relativePath).to match /\/uploads\/[0-9]{14}_hoge\/hoge\.ppt/
		expect(MetaData.create('hoge.tmp.ppt').relativePath).to match /\/uploads\/[0-9]{14}_hoge\.tmp\/hoge\.tmp\.ppt/
	end

	it "should save metadata in json format" do
		meta = MetaData.create('a.b')
		home = 'temp'
		file = double('f')
		File.should_receive(:open).with("#{home}#{meta.dirname}/.meta",'w').and_yield(file)
		JSON.should_receive(:dump).with({:filename => meta.filename, :ext => meta.ext, :created_at => meta.created_at}, file)

		meta.save(home)
	end

	it "should load metaFile" do
		dirname = "temp"
		file = double('f')
		File.should_receive(:open).with("#{dirname}/.meta", "r").and_yield(file)
		JSON.stub(:load).with(file).and_return( JSON.parse('{"filename":"testname", "ext":"ppt", "created_at":"20010101000000"}') )
		meta = MetaData.load(dirname)

		expect(meta.filename).to eq('testname')
		expect(meta.ext).to eq('ppt')
		expect(meta.created_at).to eq('20010101000000')
	end
end

