require 'spec_helper'

describe Feedback do
  it "is not stored in the db (yet?)" do
    described_class.should_not < ActiveRecord::Base
  end

  def build_feedback(attrs={})
    Feedback.new attrs.reverse_merge(body: "Does not work", email: "hein@test.clockwork.de")
  end


  context "default from 'factory'" do
    subject { build_feedback }
    it { should be_valid }
  end

  context "without a text" do
    subject { build_feedback body: '' }
    it { should_not be_valid }
  end

  context "without an email address" do
    subject { build_feedback email: '' }
    it { should_not be_valid }
  end
end

