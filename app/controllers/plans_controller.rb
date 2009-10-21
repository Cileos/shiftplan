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
    @plan = current_account.plans.build(params[:plan])

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
      @plans = current_account.plans
    end

    def set_plan
      @plan = current_account.plans.find(params[:id])
    end

    def set_employees
      @employees = current_account.employees
    end

    def set_workplaces
      @workplaces = current_account.workplaces.active
    end

    def set_qualifications
      @qualifications = current_account.qualifications
    end
end
