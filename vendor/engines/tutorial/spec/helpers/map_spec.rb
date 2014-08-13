require 'spec_helper'

describe 'The tutorial map' do
  let(:path)     { File.expand_path('../../../app/assets/images/map.svg', __FILE__) }
  let(:svg)      { Nokogiri::XML( File.read(path) ) }
  let(:markers)  { (svg / 'path[id^=tutorial_step]').map { |e| e[:id].scan(/^tutorial_step_(.*)$/) }.flatten }
  let(:chapters) { I18n.translate('tutorial.chapters').map { |c| c['id'] } }

  it 'has markers' do
    markers.should_not be_empty
  end

  context 'markers' do
    shared_examples :matching_markers_and_chapters do |locale|
      in_locale locale
      it "has a marker for every #{locale} chapter" do
        expect(chapters- markers).to eq([])
      end

      it "has a #{locale} chapter for every marker" do
        expect(markers - chapters).to eq([])
      end
    end

    it_should_behave_like :matching_markers_and_chapters, 'de'
    it_should_behave_like :matching_markers_and_chapters, 'en'
  end
end
