# encoding: UTF-8

require 'spec_helper'

describe Post do
  context "on destroy" do
    it "should destroy all its comments" do
      post = create :post
      employee = create :employee
      comment = Comment.build_from(post, employee, body: 'Blöder Kommentar')
      comment.save!

      post.comments.count.should == 1
      post.comments.should include(comment)

      post.destroy

      post.comments.reload.count.should == 0
    end
  end
end
