require 'spec_helper'

describe Notification::Post do
  let(:notification) { described_class.new notifiable: create(:post) }
  let(:post)         { create :post }

  it_behaves_like 'Notification for Dashboard'
  it_behaves_like :updating_new_notifications_count_for_user do
    let(:notifiable) { post }
  end

  context "destroyed with its post" do
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

