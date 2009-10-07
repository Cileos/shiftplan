class PlansController < ApplicationController
  def index
    redirect_to plan_path(Plan.first)
  end

  def show
    @plan = Plan.find(params[:id])
    # @plan.shifts = Shift.all
    @shifts_by_day = @plan.shifts.group_by(&:day)

    @employees = Employee.all
    @workplaces = Workplace.active
    @qualifications = Qualification.all

    render :layout => !request.xhr?
  end
end
