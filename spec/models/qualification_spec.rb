require 'spec_helper'

describe Qualification do
  it "must have a name" do
    build(:qualification, name: nil).should_not be_valid
    build(:qualification, name: '' ).should_not be_valid
  end
  it "must have an account" do
    build(:qualification, account: nil).should_not be_valid
  end

  describe "uniqueness of name" do
    let(:account) { create :account }
    let!(:qualification) do
      create :qualification, name: 'Brennstabpolierer', account: account
    end

    it "must have a unique name within account" do
      qualification = build(:qualification, name: 'Brennstabpolierer',
        account: account)
      qualification.should_not be_valid
    end
    it "must not have a unique name globally" do
      build(:qualification, name: 'Brennstabpolierer').should be_valid
    end
  end
end
