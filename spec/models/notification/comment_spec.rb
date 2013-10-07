require 'spec_helper'

describe Notification::Comment do
  let(:comment) { create :comment }
  let(:employee) { create :employee }
  let(:notification) { described_class.new notifiable: comment, employee: employee }

  it 'is destroyed with its comment' do
    notification.save!
    expect do
      comment.destroy # scheduling destroyed
    end.to change { Notification::Comment.count }.from(1).to(0)
  end

  it_behaves_like :updating_has_new_notifications_state_for_user do
    let(:notifiable) { comment }
  end
end
