require 'spec_helper'

describe Notification::Post do
  let(:notification) { described_class.new notifiable: create(:post) }
  it_should_behave_like 'Notification for Dashboard'

  context "destroyed with its post" do
    let(:post) { create :post }
    let(:employee) { create :employee }
    let(:notification) { described_class.new notifiable: post, employee: employee }

    it 'is destroyed with its post' do
      notification.save!
      expect do
        post.destroy
      end.to change { Notification::Post.count }.from(1).to(0)
    end
  end
end

