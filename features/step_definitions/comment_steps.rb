Given /^#{capture_model} has commented #{capture_model} with #{capture_quoted}$/ do |employee, commentable, text|
  employee = model! employee
  commentable = model! commentable

  Comment.build_from(commentable, employee, body: text).save!
end
