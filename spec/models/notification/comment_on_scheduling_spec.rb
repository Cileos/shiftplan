require 'spec_helper'

describe Notification::CommentOnScheduling do
  it_should_behave_like 'Notification for Dashboard'
  let(:author)  { create(:employee, user: create(:confirmed_user)) }
  let(:comment) { Comment.build_from(create(:scheduling), author, body: 'Mein Senf dazu!').tap(&:save!) }
  let(:recipient) { create(:employee, user: create(:confirmed_user)) }
  let(:notification) { described_class.new(employee: recipient, notifiable: comment) }

  before(:each) do
    Timecop.freeze(Time.parse('2012-12-12 12:23:00'))
  end

  it 'should set the sent_at field to the current time after delivering the notification mail' do
    expect { notification.save! }.to change(notification, :sent_at).from(nil).to(Time.zone.now)
  end
end
