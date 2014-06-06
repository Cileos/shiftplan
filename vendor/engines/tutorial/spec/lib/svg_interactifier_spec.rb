require 'spec_helper'

require 'svg_interactifier'

describe SvgInteractifier do
  context '#interactify' do
    def svg(inner)
      %Q~<svg inkscape:version="0.48"> #{inner} </svg>~
    end

    def interactify(x, *a)
      described_class.new.interactify( svg(x), *a )
    end

    it 'does not touch g element' do
      interactify('<g> <path /> </g>').should have_selector('g')
    end

    it 'does not touch svg' do
      interactify('  ').should have_selector('svg')
    end

    # we want to be able to set viewBox by Ember properties, but cannot replace root node
    xit 'makes the svg root interactive' do
      res = interactify('')
      res.should_not have_selector('svg')
      res.should include %Q~{{interactive-svg}}~
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
        result.should_not have_selector('path')
      end
    end
  end

end

