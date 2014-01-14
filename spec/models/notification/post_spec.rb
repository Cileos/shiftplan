require 'spec_helper'

describe Notification::Post do
  let(:notification) { described_class.new notifiable: create(:post) }
  let(:post)         { create :post }

  it_behaves_like 'Notification for Dashboard'
  it_behaves_like :updating_new_notifications_count_for_user do
    let(:notifiable) { post }
  end
end

