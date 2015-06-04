module Helpers
  def deleteUploaded(path)
    [path, File.join(path, "**", "*.*")].each do |p|
      FileUtils.rm_r(Dir.glob(p), {:force=>true})
    end
  end

  def getMetaDataForDisplay(dirname, page)
    dirs = Dir.glob("#{dirname}/*/").select{|e| File.exists?("#{e}.meta")}.sort.reverse
    metaDataArray = Array.new
    dirs[(page-1)*15..page*15-1].each{ |d|
      metaDataArray << MetaData.load(settings.public_folder, d)
    }
    pagenum = dirs.size() % 15 == 0? dirs.size() / 15 : (dirs.size() / 15) + 1
    return metaDataArray, pagenum
  end
end
