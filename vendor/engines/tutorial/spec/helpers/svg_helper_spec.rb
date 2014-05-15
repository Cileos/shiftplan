require 'spec_helper'

describe SvgHelper, type: 'helper' do
  describe '#interactify' do
    def svg(inner)
      %Q~<svg inkscape:version="0.48"> #{inner} </svg>~
    end

    def interactify(x, *a)
      helper.interactify( svg(x), *a )
    end

    it 'does not touch svg' do
      interactify('  ').should have_selector('svg')
    end

    describe 'with paths matching our preference' do
      let(:path_xml) { '<path id="tutorial_foo" d="long"></path>' }
      let(:result) { interactify(path_xml) }

      it 'adds handlebar component version of the wanted paths' do
        result.should include(
          %Q~{{interactive-path id="tutorial_foo" d="long"}}~
        )
      end

      it 'removes the original element' do
        result.should_not have_selector('svg path')
      end
    end
  end
end
