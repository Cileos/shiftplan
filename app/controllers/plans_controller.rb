class PlansController < ApplicationController
  before_filter :set_plans,          :only => :index
  before_filter :set_plan,           :only => :show
  before_filter :set_employees,      :only => :show
  before_filter :set_workplaces,     :only => :show
  before_filter :set_qualifications, :only => :show

  def index
  end

  def show
  end

  def create
    @plan = Plan.new(params[:plan])

    if @plan.save
      flash[:notice] = t(:plan_successfully_created)
      redirect_to plans_path
    else
      flash[:error] = t(:plan_could_not_be_created)
      render :action => 'index'
    end
  end

  protected

    def set_plans
      @plans = Plan.all
    end

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
