# used by Ember to fetch list of employees to manage unavailabilities on
module Ember
  class EmployeesController < InheritedResources::Base
    skip_authorization_check

    respond_to :json

    def collection
      if params[:reason] == 'unavailabilities'
        current_user.plannable_employees
      else
        []
      end
    end
  end
end
