# used by Ember to fetch list of employees to manage unavailabilities on
module Ember
  class EmployeesController < BaseController
    respond_to :json

    def collection
      if params[:reason] == 'unavailabilities'
        current_user.plannable_employees
      end
    end
  end
end
