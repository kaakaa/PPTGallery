module Helpers
        def deleteUploaded(path)
                FileUtils.rm_r(Dir.glob(File.join(path, "**", "*.*")), {:force=>true})
                FileUtils.rm_r(Dir.glob(path), {:force=>true})
        end

        def getMetaDataForDisplay(dirname, page)
                dirs = Dir.glob("#{dirname}/*/").sort.reverse
                metaDataArray = Array.new
                dirs[(page-1)*15..page*15-1].each{ |d|
                        metaDataArray << MetaData.load(settings.public_folder, d)
                }
                pagenum = dirs.size() % 15 == 0? dirs.size() / 15 : (dirs.size() / 15) + 1
                return metaDataArray, pagenum
        end
end
