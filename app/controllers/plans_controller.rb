class PlansController < ApplicationController
  def index
    redirect_to plan_path(1)
  end

  def show
    @shifts = Shift.all

    @days = @shifts.first.start.to_date..(@shifts.first.start + 7.days).to_date # temporary

    @employees = Employee.all
    @workplaces = Workplace.active

    render :layout => !request.xhr?
  end
end
