require 'spec_helper'

describe PlanTemplate do
  it "must have a name" do
    build(:plan_template, name: nil).should_not be_valid
    build(:plan_template, name: '' ).should_not be_valid
  end
  it "must have an organization" do
    build(:plan_template, organization: nil).should_not be_valid
  end
  it "must have an template type" do
    build(:plan_template, template_type: nil).should_not be_valid
  end
  it "must have a valid template type" do
    build(:plan_template, template_type: 'doesnotexist').should_not be_valid
  end

  describe "uniqueness of name" do
    let(:organization) { create :organization }
    let!(:plan_template) do
      create :plan_template, name: 'Brennstabpolierer', organization: organization
    end

    it "must have a unique name within organization" do
      plan_template = build(:plan_template, name: 'Brennstabpolierer',
        organization: organization)
      plan_template.should_not be_valid
    end
    it "must not have a unique name globally" do
      build(:plan_template, name: 'Brennstabpolierer').should be_valid
    end
  end
end
