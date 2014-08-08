class Setup < ActiveRecord::Base
  belongs_to :user

  def execute!
    # TODO create ALL the stuff like Signup does currently
  end
end
