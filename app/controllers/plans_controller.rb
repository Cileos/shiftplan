class PlansController < ApplicationController
  before_filter :set_plan,           :only => :show
  before_filter :set_employees,      :only => :show
  before_filter :set_workplaces,     :only => :show
  before_filter :set_qualifications, :only => :show
  
  def index
    redirect_to plan_path(Plan.first)
  end

  def show
    render :layout => !request.xhr?
  end

  protected
  
    def set_plan 
      @plan = Plan.find(params[:id])
    end
  
    def set_employees
      @employees = Employee.all
    end
  
    def set_workplaces
      @workplaces = Workplace.active
    end
  
    def set_qualifications
      @qualifications = Qualification.all
    end
end
