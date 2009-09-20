class PlansController < ApplicationController
  def index
  end

  def show
    @employees = Employee.all
    @workplaces = Workplace.active

    render :layout => !request.xhr?
  end
end
