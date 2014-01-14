# encoding: UTF-8

require 'spec_helper'

describe Post do

  context "on destroy" do

    let(:post) { create(:post) }

    it "comments are destroyed" do
      employee = create :employee
      comment = Comment.build_from(post, employee, body: 'Blöder Kommentar')
      comment.save!

      post.comments.count.should == 1
      post.comments.should include(comment)

      post.destroy

      post.comments.reload.count.should == 0
    end

    it "notifications are destroyed" do
      destroyer = instance_double("NotificationDestroyer")
      NotificationDestroyer.should_receive(:new).with(post).and_return(destroyer)
      destroyer.should_receive(:destroy!)

      post.destroy
    end

  end
end
