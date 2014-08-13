require 'spec_helper'

describe SvgHelper, type: 'helper' do
  describe '#interactify' do
    it 'runs SvgInteractifier#interactify' do
      xml = double
      interactifier = instance_double 'SvgInteractifier', interactify: (result = double)
      SvgInteractifier.stub new: interactifier
      helper.interactify(xml).should == result
    end
  end

end
