# encoding: UTF-8
require 'quick_magick'
module QuickMagickProcessor
  extend self
  def image_to_tiff
    tmp_file = Tempfile.new(["",".tif"])
    cat = @instance || read_with_processor(@source.to_s)
    # cat.format("tif")
    #cat.crop(@x, @y, @w, @h) unless [@x, @y, @w, @h].compact == []
    #cat.crop("#{@x}x#{@y}+#{@w}+#{@h}") unless [@x, @y, @w, @h].compact == []
    cat.crop("#{@w}x#{@h}+#{@x}+#{@y}") unless [@x, @y, @w, @h].compact == []
    cat.write tmp_file.path.to_s
    return tmp_file
  end

  def read_with_processor(path)
    #QuickMagick::Image.open(path.to_s)
    QuickMagick::Image.read(path.to_s).first
  end

  def is_a_instance?(object)
    object.class == QuickMagick::Image
  end
end

