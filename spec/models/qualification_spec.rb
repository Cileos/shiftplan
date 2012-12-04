require 'spec_helper'

describe Qualification do
  it "must have a name" do
    build(:qualification, name: nil).should_not be_valid
    build(:qualification, name: '' ).should_not be_valid
  end
  it "must have an organization" do
    build(:qualification, organization: nil).should_not be_valid
  end

  describe "uniqueness of name" do
    let(:organization) { create :organization }
    let!(:qualification) do
      create :qualification, name: 'Brennstabpolierer', organization: organization
    end

    it "must have a unique name within organization" do
      qualification = build(:qualification, name: 'Brennstabpolierer',
        organization: organization)
      qualification.should_not be_valid
    end
    it "must not have a unique name globally" do
      build(:qualification, name: 'Brennstabpolierer').should be_valid
    end
  end
end
