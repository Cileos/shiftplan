require 'spec_helper'

describe Notification::CommentOnScheduling do
  it 'should set the sent_at field to the current time after sending the notification mail' do
    Timecop.freeze(Time.parse('2012-12-12 12:23:00'))
    now = Time.now

    author = create(:employee, user: create(:confirmed_user))
    comment = Comment.build_from(create(:scheduling), author, body: 'Mein Senf dazu!')
    comment.save!

    recipient = create(:employee, user: create(:confirmed_user))
    notification = Notification::CommentOnScheduling.new(employee: recipient, notifiable: comment)

    notification.sent_at.should be_nil

    notification.save!

    notification.reload.sent_at.should ==  now
  end
end
