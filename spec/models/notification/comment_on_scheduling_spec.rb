require 'spec_helper'

describe Notification::CommentOnScheduling do
  let(:author)  { create(:employee, user: create(:confirmed_user)) }
  let(:comment) { Comment.build_from(create(:scheduling), author, body: 'Mein Senf dazu!').tap(&:save!) }
  let(:recipient) { create(:employee, user: create(:confirmed_user)) }
  let(:notification) { described_class.new(employee: recipient, notifiable: comment) }

  it_should_behave_like 'Notification for Dashboard'
end
