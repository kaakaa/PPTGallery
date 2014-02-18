require File.expand_path('../lib/pptgallery/meta_data', File.dirname(__FILE__))

describe MetaData do

        before :all do
                Dir.mkdir(upload_path) if !Dir.exists?(upload_path)
		@root = File.expand_path('..', upload_path)
        end

        after :all do
                clear_all
        end

	it "should get MetaData properties" do
		meta = MetaData.create(@root, 'sample.ppt')
		expect(meta.dirname).to match /#{upload_path}\/[0-9]{14}_sample/
		expect(meta.htmlPath).to match /^\/uploads\/[0-9]{14}_sample\/sample\.html$/
		expect(meta.thumnailPath).to match /^\/uploads\/[0-9]{14}_sample\/png\/page001\.png$/
		expect(meta.pdfPath).to match /^\/uploads\/[0-9]{14}_sample\/sample\.pdf$/
		expect(meta.relativePath).to match /^\/uploads\/[0-9]{14}_sample\/sample\.ppt$/
	end

	it "should get MetaData properties having two periods" do
		meta = MetaData.create(@root, 'sample.tmp.ppt')
		expect(meta.dirname).to  match /#{upload_path}\/[0-9]{14}_sample\.tmp/
		expect(meta.htmlPath).to match /^\/uploads\/[0-9]{14}_sample\.tmp\/sample\.tmp\.html$/
		expect(meta.thumnailPath).to match /^\/uploads\/[0-9]{14}_sample\.tmp\/png\/page001\.png$/
		expect(meta.pdfPath).to match /^\/uploads\/[0-9]{14}_sample\.tmp\/sample\.tmp\.pdf$/
		expect(meta.relativePath).to match /^\/uploads\/[0-9]{14}_sample\.tmp\/sample\.tmp\.ppt$/
	end

	it "should save metadata in json format" do
		meta = MetaData.create(upload_path, 'a.b')
		file = double('f')
		File.should_receive(:open).with(File.join(meta.dirname, '.meta') ,'w').and_yield(file)
		JSON.should_receive(:dump).with({:filename => meta.filename, :ext => meta.ext, :created_at => meta.created_at}, file)

		meta.save()
	end

	it "should load metaFile" do
		dirname = "temp"
		file = double('f')
		File.should_receive(:open).with("#{dirname}/.meta", "r").and_yield(file)
		JSON.stub(:load).with(file).and_return( JSON.parse('{"filename":"testname", "ext":"ppt", "created_at":"20010101000000"}') )
		meta = MetaData.load(upload_path, dirname)

		expect(meta.filename).to eq('testname')
		expect(meta.ext).to eq('ppt')
		expect(meta.created_at).to eq('20010101000000')
	end
end

