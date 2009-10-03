require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Color do
  describe "class methods" do
    describe ".hsv_to_rgb" do
      Color.hsv_to_rgb(0, 0, 0).should         == [0, 0, 0]
      Color.hsv_to_rgb(0, 0.25, 0.25).should   == [63, 47, 47]
      Color.hsv_to_rgb(0, 0.5, 0.5).should     == [127, 63, 63]
      Color.hsv_to_rgb(0, 0.75, 0.75).should   == [191, 47, 47]
      Color.hsv_to_rgb(0, 1, 1).should         == [255, 0, 0]

      Color.hsv_to_rgb(50, 0, 0).should        == [0, 0, 0]
      Color.hsv_to_rgb(50, 0.25, 0.25).should  == [63, 61, 47]
      Color.hsv_to_rgb(50, 0.5, 0.5).should    == [127, 116, 63]
      Color.hsv_to_rgb(50, 0.75, 0.75).should  == [191, 167, 47]
      Color.hsv_to_rgb(50, 1, 1).should        == [255, 212, 0]

      Color.hsv_to_rgb(100, 0, 0).should       == [0, 0, 0]
      Color.hsv_to_rgb(100, 0.25, 0.25).should == [53, 63, 47]
      Color.hsv_to_rgb(100, 0.5, 0.5).should   == [85, 127, 63]
      Color.hsv_to_rgb(100, 0.75, 0.75).should == [95, 191, 47]
      Color.hsv_to_rgb(100, 1, 1).should       == [84, 255, 0]

      Color.hsv_to_rgb(200, 0, 0).should       == [0, 0, 0]
      Color.hsv_to_rgb(200, 0.25, 0.25).should == [47, 58, 63]
      Color.hsv_to_rgb(200, 0.5, 0.5).should   == [63, 106, 127]
      Color.hsv_to_rgb(200, 0.75, 0.75).should == [47, 143, 191]
      Color.hsv_to_rgb(200, 1, 1).should       == [0, 169, 255]

      Color.hsv_to_rgb(350, 0, 0).should       == [0, 0, 0]
      Color.hsv_to_rgb(350, 0.25, 0.25).should == [63, 47, 50]
      Color.hsv_to_rgb(350, 0.5, 0.5).should   == [127, 63, 74]
      Color.hsv_to_rgb(350, 0.75, 0.75).should == [191, 47, 71]
      Color.hsv_to_rgb(350, 1, 1).should       == [255, 0, 42]
    end

    describe ".rgb_to_hex" do
      Color.rgb_to_hex(0, 0, 0).should       == '000000'
      Color.rgb_to_hex(128, 128, 128).should == '808080'
      Color.rgb_to_hex(255, 255, 255).should == 'ffffff'
    end
  end
end
