require 'spec_helper'

describe Notification::CommentOnPostOfEmployee do
  let(:comment)      { create(:comment, commentable: create(:post)) }
  let(:notification) { described_class.new(notifiable: comment) }

  it_should_behave_like 'Notification for Dashboard'
  it_behaves_like :updating_has_new_notifications_state_for_user do
    let(:notifiable) { comment }
  end
end

