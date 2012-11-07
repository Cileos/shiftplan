require 'spec_helper'

describe WithinPlanPeriodValidator do
  let(:plan) { mock 'Plan', starts_at: 1.day.from_now }
  let(:record) { mock('Record', plan: plan) }
  let(:validator) { described_class.new(attributes: [:starts_at]) }

  def validate!
    validator.validate_each( record, :starts_at, value )
  end

  context "given nil value" do
    let(:value) { nil }
    it "should not break" do
      expect { validate! }.not_to raise_error
    end
  end
end
