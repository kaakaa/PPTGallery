require 'haml'
require 'pptgallery/conv/pdf'
require 'pptgallery/conv/png'
require 'pptgallery/conv/html'

class Slide
  def initialize(settings, m)
    @root = settings.root 
    @home = settings.public_folder
    @meta = m
  end

  def upload(ip, contents)
    saveUploaded(contents)
    MyLogger.log.info "#{ip} : #{@meta.filename} saved."

    PDF.convert(@meta) unless @meta.ext == 'pdf'
    MyLogger.log.info "#{ip} : Complete converting to PDF."

    PNG.convert(@meta)
    MyLogger.log.info "#{ip} : Complete converting to PNG."

    # makeHtml()
    HTML.create(@meta, @home)
    MyLogger.log.info "#{ip} : Complete making HTML."

    MyLogger.log.info "#{ip} : Complete uploading."
  end

  def saveUploaded(contents)
    File.open(uploadedFilePath, "w") do |f|
      f.write(contents)
    end
  end

  def uploadedFilePath
    File.join(@meta.dirname, "#{@meta.filename}.#{@meta.ext}")
  end
end
