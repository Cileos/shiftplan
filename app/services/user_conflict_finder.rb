# Find conflicts for a User
#  * given schedulings are not tested for owner (employee/user)
#  * all schedulings of each employee of user are taken into consideration
#
# Answers: "What are conflicts for the user?"
class UserConflictFinder < ConflictFinder
  private


  # employees of users of employees in schedulings
  def employee_ids
    user_ids = Employee.where(id: super).pluck('DISTINCT user_id')
    Employee.where( user_id: user_ids).pluck('DISTINCT id')
  end

  def overlapping?(x,y)
    x != y && x.cover?(y)
  end
end
