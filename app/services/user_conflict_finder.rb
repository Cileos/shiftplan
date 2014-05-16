# Find conflicts for a User
#  * given schedulings are not tested for owner (employee/user)
#  * all schedulings of each employee of user are taken into consideration
#
# Answers: "What are conflicts for the user?"
#
# She can even see conflicts in her other accounts
# She can even see details of her conflicts
class UserConflictFinder < ConflictFinder
  def call(*a)
    super
    conflicts.each(&:show_details!)
  end
  private


  # employees of users of employees in schedulings
  def scheduling_employee_ids
    user_ids = Employee.where(id: super).pluck('DISTINCT user_id')
    Employee.where( user_id: user_ids).pluck('DISTINCT id')
  end

  def overlapping?(x,y)
    x != y && x.cover?(y)
  end
end
