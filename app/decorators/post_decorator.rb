class PostDecorator < ApplicationDecorator
  decorates :post

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :posts
      'div.posts'
    when :post
      "div#post_#{resource.id}"
    else
      super
    end
  end

  def blog
    post.blog
  end

  def update_posts
    select(:posts).refresh_html posts_list
  end

  def update_post
    select(:post, post).refresh_html post_details
  end

  def posts_list
    h.render('posts/posts_with_pagination', posts: h.collection)
  end

  def post_details
    h.render('posts/post_details', post: post, truncation: false)
  end

  def respond
    unless errors.empty?
      prepend_errors_for(post)
    else
      clear_modal
      update_posts
      update_post
      update_flash
    end
  end
end
