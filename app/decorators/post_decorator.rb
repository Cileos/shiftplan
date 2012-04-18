class PostDecorator < ApplicationDecorator
  decorates :post

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :posts
      'div.posts'
    else
      super
    end
  end

  def update_posts
    select(:posts).html posts_list
  end

  def posts_list
    h.render('posts/list', posts: h.company_blog_posts)
  end

  def respond
    unless errors.empty?
      prepend_errors_for(post)
    else
      hide_modal
      update_posts
      update_flash
    end
  end
end
