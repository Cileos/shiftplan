class DashboardsController < ApplicationController
  before_filter :set_activities

  def show
    @number_of_employees      = current_account.employees.count
    @number_of_qualifications = current_account.qualifications.count
    @number_of_workplaces     = current_account.workplaces.count
  end

  protected

    def set_activities
      @current_activities    = current_account.activities.unaggregated.order('created_at DESC')
      @aggregated_activities = current_account.activities.aggregated.order('created_at DESC')
    end
end