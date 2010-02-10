class DashboardsController < ApplicationController
  def show
    @number_of_employees      = current_account.employees.count
    @number_of_qualifications = current_account.qualifications.count
    @number_of_workplaces     = current_account.workplaces.count
  end
end