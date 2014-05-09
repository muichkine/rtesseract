# encoding: UTF-8
class RTesseract
  # Class to read char positions from an image
  class Box < RTesseract
    def initialize(src = '', options = {})
      @options = command_line_options(options)
      @value, @x, @y, @w, @h = [[]]
      @processor = RTesseract.choose_processor!(@processor)
      @source = @processor.image?(src) ? src : Pathname.new(src)
    end

    def characters
      convert if @value == []
      @value
    end

    def text_file
      @text_file = Pathname.new(Dir.tmpdir).join("#{Time.now.to_f}#{rand(1500)}.box").to_s
    end

    def config
      @options ||= {}
      @options.map { |k, v| "#{k} #{v}" }.join("\n")
    end

    def convert_text(text)
      text_objects = []
      text.each_line do |line|
        char, width, height, x, y = line.split(" ")
        text_objects << {:char => char, :width => width.to_i, :height => height.to_i , :x => x.to_i, :y => y.to_i}
      end
      @value = text_objects
    end

    # Convert image to string
    def convert
      @options ||= {}
      @options['tessedit_create_boxfile'] = 1
      `#{@command} "#{image}" "#{text_file.gsub('.box','')}" #{lang} #{psm} #{config_file} #{clear_console_output}`
      convert_text(File.read(@text_file).to_s)
      remove_file([@image, @text_file])
    rescue => error
      raise RTesseract::ConversionError.new(error)
    end

    def source=(src)
      @value = []
      @source = @processor.image?(src) ? src : Pathname.new(src)
    end


    #=================================
    def self.read(src = nil, options = {}, &block)
      fail RTesseract::ImageNotSelectedError if src.nil?
      processor = RTesseract.choose_processor!(options.delete(:processor) || options.delete('processor'))
      image = processor.read_with_processor(src.to_s)

      yield image
      object = RTesseract.new('', options)
      object.from_blob(image.to_blob)
      object
    end


    # Crop image to convert
    def crop!(x, y, width, height)
      @value = []
      @x, @y, @w, @h = x.to_i, y.to_i, width.to_i, height.to_i
      self
    end

    # Read image from memory blob
    def from_blob(blob)
      blob_file = Tempfile.new('blob')
      blob_file.write(blob)
      blob_file.rewind
      blob_file.flush
      self.source = blob_file.path
      convert
      remove_file([blob_file])
    rescue => error
      raise RTesseract::ConversionError.new(error)
    end

    # Output value
    def to_s
      return @value if @value != ''
      if @processor.image?(@source) || @source.file?
        convert
        @value
      else
        fail RTesseract::ImageNotSelectedError.new(@source)
      end
    end

  end
end
