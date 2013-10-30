require 'spec_helper'

describe AttachedDocument do
  it 'needs a file' do
    build(:attached_document, file: nil).should_not be_valid
  end

  let(:file_path) { Rails.root.join('factories/attached_documents/howto.docx') }

  describe '#name' do
    it 'falls back to filename' do
      doc = create(:attached_document, file: File.open(file_path))
      reloaded = described_class.find doc.id
      reloaded.name.should == 'howto.docx'
    end
  end
end
