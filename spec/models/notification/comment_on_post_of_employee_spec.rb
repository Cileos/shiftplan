require 'spec_helper'

describe Notification::CommentOnPostOfEmployee do
  let(:notification) { described_class.new notifiable: create(:comment, commentable: create(:post) ) }
  it_should_behave_like 'Notification for Dashboard'
end

