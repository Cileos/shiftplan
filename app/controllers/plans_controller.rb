class PlansController < ApplicationController
  def index
    redirect_to plan_path(1)
  end

  def show
    @employees = Employee.all
    @workplaces = Workplace.active

    render :layout => !request.xhr?
  end
end
