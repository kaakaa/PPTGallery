require 'RMagick'
require 'haml'

require File.expand_path('cmd_executor', File.dirname(__FILE__))

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

    savePdf()
    MyLogger.log.info "#{ip} : Complete converting to PDF."

    savePng()
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

  def savePdf
    if @meta.ext == 'pdf'
      return
    end
    pdfPath = File.join(@meta.dirname, "#{@meta.filename}.pdf")
    CommandExecutor.jodconverter(uploadedFilePath, pdfPath)
  end

  def savePng
    Dir.mkdir(File.join(@meta.dirname, "img"))
    Dir.mkdir(File.join(@meta.dirname, "img_low"))

    pdf = File.join(@meta.dirname, "#{@meta.filename}.pdf")

    writeSlideImages('img', pdf, {:quality => 80, :density => '150'})
    writeSlideImages('img_low', pdf, {:quality => 10, :density => '50'})
  end

  def writeSlideImages(dirname, file, options = {})
    getImageList(file, options).each_with_index do |img, index|
      path = File.join(@meta.dirname, dirname, "page#{format("%03d", index+1)}.jpg")
      img.write(path)
    end
  end

  def getImageList(file, options = {})
    Magick::ImageList.new(file) do
      self.format = options[:format] || 'JPEG'
      self.quality = options[:quality] || 100
      self.density = options[:density] || '100'
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
