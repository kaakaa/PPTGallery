require 'spec_helper'

describe Helpers do
	include Helpers

	context 'deleteUploaded' do
		before :each do
			@tmpDir = File.join(upload_path, 'tmp')
			sonDir = File.join(@tmpDir, 'son')
			Dir.mkdir(@tmpDir)
			Dir.mkdir(sonDir)
			File.open(File.join(@tmpDir, 'sample.txt'), 'w') {|f| f.write("sample file") }
			File.open(File.join(sonDir, 'sample.txt'), 'w') {|f| f.write("sample file") }
		end

		it 'can delete directory' do
			deleteUploaded(@tmpDir)
			expect(Dir.glob(File.join(@tmpDir, '*')).count).to eq(0)
		end
	end
end
