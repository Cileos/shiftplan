require 'spec_helper'

describe Notification::CommentOnScheduling do
  let(:author)  { create(:employee, user: create(:confirmed_user)) }
  let(:comment) { Comment.build_from(create(:scheduling), author, body: 'Mein Senf dazu!').tap(&:save!) }
  let(:recipient) { create(:employee, user: create(:confirmed_user)) }

  before(:each) do
    Timecop.freeze(Time.parse('2012-12-12 12:23:00'))
  end

  it 'should set the sent_at field to the current time after delivering the notification mail' do
    now = Time.now
    notification = Notification::CommentOnScheduling.new(employee: recipient, notifiable: comment)

    notification.sent_at.should be_nil

    notification.save!

    notification.reload.sent_at.should ==  now
  end
end
