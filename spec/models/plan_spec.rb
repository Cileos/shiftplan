require 'spec_helper'

describe Plan do
  context 'duration' do
    it "should default to 1 week" do
      plan = described_class.new
      plan.duration.should == '1_week'
    end
  end

  context "name" do
    let(:organization) { create :organization }
    let!(:existing) { create :plan, organization: organization, name: name }
    let(:name)         { 'The one and only' }

    def build_named_plan(attrs={})
      build :plan, attrs.reverse_merge(name: name)
    end

    context "within an organization" do
      let(:plan) { build_named_plan organization: organization }
      it "must be uniq" do
        plan.should_not be_valid
        plan.should have_at_least(1).error_on(:name)
      end
    end

    context "within an account" do
      let(:other_org) { create :organization, account: organization.account }
      let(:plan) { build_named_plan organization: other_org}
      it "does not need to be unique" do
        plan.should be_valid
      end
    end

    context "by different accounts" do
      let(:plan) { build_named_plan }
      it "does not need to be unique" do
        plan.should be_valid
      end
    end

  end

end
