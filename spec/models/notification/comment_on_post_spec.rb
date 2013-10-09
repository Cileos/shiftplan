require 'spec_helper'

describe Notification::CommentOnPost do
  let(:comment)      { create(:comment, commentable: create(:post)) }
  let(:notification) { described_class.new(notifiable: comment) }

  it_should_behave_like 'Notification for Dashboard'
  it_behaves_like :updating_new_notifications_count_for_user do
    let(:notifiable) { comment }
  end
end

