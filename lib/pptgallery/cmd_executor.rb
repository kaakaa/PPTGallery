require 'libreconv'

class CommandExecutor
  def self.convert(inputPath, outputPath)
    MyLogger.log.info "#{inputPath} -> #{outputPath}"
    Libreconv.convert(inputPath,outputPath)
  end
end
