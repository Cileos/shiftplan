class Notification::AnswerOnCommentOfEmployeeOnSchedulingOfEmployee < Notification::CommentOnScheduling

  def introductory_text_options
    super.except(:employee_name)
  end
end

