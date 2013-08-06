class SchedulingCommentsController < CommentsController
  belongs_to :account, :organization, :plan, :scheduling
end
