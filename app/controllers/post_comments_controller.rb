class PostCommentsController < CommentsController
  nested_belongs_to :account, :organization, :blog, :post
end
