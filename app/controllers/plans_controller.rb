class PlansController < ApplicationController
  def index
    redirect_to plan_path(1)
  end

  def show
    @shifts = Shift.all
    @shifts_by_day = @shifts.group_by(&:day)

    @days = @shifts.first.start.to_date..(@shifts.first.start + 7.days).to_date # temporary

    @employees = Employee.all
    @workplaces = Workplace.active
    @qualifications = Tagging.find(:all, :conditions => "context = 'qualifications'").map(&:tag).uniq

    render :layout => !request.xhr?
  end
end
