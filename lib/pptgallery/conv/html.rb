require 'haml'

class HTML
  def self.create(meta,home)
    @meta = meta
    @home = home
    images = getImages('img')
    images_low = getImages('img_low')
    source = partial('slide.haml', {:images => images, :images_low => images_low, :title => @meta.filename})
    File.write(File.join(@meta.dirname, "#{@meta.filename}.html"), source) if !source.nil?
  end

  def self.getImages(dirname)
    Dir.glob(File.join(@meta.dirname, dirname, "*.jpg")).sort!.collect{ |img|
      img.gsub!(/#{@home}/, '')
    }
  end

  def self.partial(filename, options={})
    contents = File.read(File.expand_path("../templates/#{filename}", File.dirname(__FILE__)))
    Haml::Engine.new(contents).render(self, options.merge!(:layout => false))
  end
end
