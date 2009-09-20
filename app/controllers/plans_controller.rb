class PlansController < ApplicationController
  def index
    redirect_to plan_path(1)
  end

  def show
    @plan = Plan.new
    @plan.shifts = Shift.all
    @shifts_by_day = @plan.shifts.group_by(&:day)

    @employees = Employee.all
    @workplaces = Workplace.active
    @qualifications = Tagging.find(:all, :conditions => "context = 'qualifications'").map(&:tag).uniq

    render :layout => !request.xhr?
  end
end
