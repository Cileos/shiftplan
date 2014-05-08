require 'spec_helper'

describe Notification::CommentOnPostForCommenter do
  let(:comment)      { create(:comment, commentable: create(:post)) }
  let(:notification) { described_class.new(notifiable: comment) }

  it_should_behave_like 'Notification for Dashboard'
end
