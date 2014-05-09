# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Rtesseract::Box" do
  before do
    @path = Pathname.new(__FILE__.gsub("rtesseract_box_spec.rb","")).expand_path
    @image_tiff = @path.join("images","test.tif").to_s
  end


  it "bounding box" do
    RTesseract::Box.new(@image_tiff).characters.is_a?(Array).should be_true
    RTesseract::Box.new(@image_tiff).characters.should eql([{:char=>"4", :width=>145, :height=>14, :x=>159, :y=>33}, {:char=>"3", :width=>184, :height=>14, :x=>196, :y=>33}, {:char=>"Z", :width=>219, :height=>14, :x=>236, :y=>33}, {:char=>"Z", :width=>255, :height=>14, :x=>269, :y=>33}])

  end
end
