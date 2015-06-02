require 'RMagick'

class PNG
  def self.convert(meta)
    @meta = meta
    Dir.mkdir(File.join(@meta.dirname, "img"))
    Dir.mkdir(File.join(@meta.dirname, "img_low"))

    pdf = File.join(@meta.dirname, "#{@meta.filename}.pdf")

    writeSlideImages('img', pdf, {:quality => 80, :density => '150'})
    writeSlideImages('img_low', pdf, {:quality => 10, :density => '50'})
  end

  def self.writeSlideImages(dirname, file, options = {})
    getImageList(file, options).each_with_index do |img, index|
      path = File.join(@meta.dirname, dirname, "page#{format("%03d", index+1)}.jpg")
      img.write(path)
    end
  end

  def self.getImageList(file, options = {})
    Magick::ImageList.new(file) do
      self.format = options[:format] || 'JPEG'
      self.quality = options[:quality] || 100
      self.density = options[:density] || '100'
    end
  end
end
