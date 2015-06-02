require 'libreconv'

class PDF
  def self.convert(meta)
    output = File.join(meta.dirname, "#{meta.filename}.pdf")
    Libreconv.convert(meta.uploaded, output)
  end
end
