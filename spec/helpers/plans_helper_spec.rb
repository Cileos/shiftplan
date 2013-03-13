require 'spec_helper'

describe PlansHelper do
  context "cwdays_for_select" do
    let(:scheduling) { stub('scheduling', date: Time.zone.now.to_date).as_null_object }
    it "offers all days of the week" do
      helper.cwdays_for_select(scheduling).should have(7).items
    end
  end
end
