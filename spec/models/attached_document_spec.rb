require 'spec_helper'

describe AttachedDocument do
  it 'needs a file' do
    build(:attached_document, file: nil).should_not be_valid
  end
end
