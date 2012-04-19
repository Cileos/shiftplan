# encoding: UTF-8

require 'spec_helper'

describe Blog do
  context "on destroy" do
    it "should destroy all its posts and the comments of all posts" do
      blog = Factory :blog
      post = Factory :post, blog: blog
      employee = Factory :employee
      comment = Comment.build_from(post, employee, body: 'Blöder Kommentar')
      comment.save!

      blog.posts.count.should == 1
      blog.posts.should include(post)
      post.comments.count.should == 1
      post.comments.should include(comment)

      blog.destroy

      blog.posts.reload.count.should == 0
      post.comments.reload.count.should == 0
    end
  end
end
