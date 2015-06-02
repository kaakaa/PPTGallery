require 'RMagick'
require 'haml'
require 'pptgallery/conv/pdf'
require 'pptgallery/conv/png'

# require File.expand_path('cmd_executor', File.dirname(__FILE__))

class UploadedFile
  def initialize(root, home, m)
    @root = root
    @home = home
    @meta = m
    Dir.mkdir(@meta.dirname) if !Dir.exist?(@meta.dirname)
  end

  def convert(ip, tempfile)
    saveUploaded(tempfile)
    MyLogger.log.info "#{ip} : #{@meta.filename} saved."

    PDF.convert(@meta) unless @meta.ext == 'pdf'
    MyLogger.log.info "#{ip} : Complete converting to PDF."

    PNG.convert(@meta)
    MyLogger.log.info "#{ip} : Complete converting to PNG."

    makeHtml()
    MyLogger.log.info "#{ip} : Complete making HTML."

    createMetaFile()
    MyLogger.log.info "#{ip} : Complete creating .meta."
    MyLogger.log.info "#{ip} : Complete uploading."
  end

  def saveUploaded(uploadedFile)
    File.open(uploadedFilePath, "w") do |f|
      f.write(uploadedFile.read)
    end
  end

  def makeHtml
    images = getImages('img')
    images_low = getImages('img_low')
    source = partial('slide.haml', {:images => images, :images_low => images_low, :title => @meta.filename})
    File.write(File.join(@meta.dirname, "#{@meta.filename}.html"), source) if !source.nil?
  end

  def getImages(dirname)
    Dir.glob(File.join(@meta.dirname, dirname, "*.jpg")).sort!.collect{ |img|
      img.gsub!(/#{@home}/, '')
    }
  end

  def createMetaFile
    @meta.save()
  end
    def uploadedFilePath
    File.join(@meta.dirname, "#{@meta.filename}.#{@meta.ext}")
  end

  def partial(filename, options={})
    contents = File.read(File.expand_path("templates/#{filename}", File.dirname(__FILE__)))
    Haml::Engine.new(contents).render(self, options.merge!(:layout => false))
  end
end
