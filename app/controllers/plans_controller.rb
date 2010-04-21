class PlansController < ApplicationController
  before_filter :set_plans,          :only => :index
  before_filter :set_plan,           :only => [:index, :show, :update, :destroy]
  before_filter :set_employees,      :only => :show
  before_filter :set_workplaces,     :only => :show
  before_filter :set_qualifications, :only => :show

  before_filter :set_templates,      :only => :index
  before_filter :set_template,       :only => :create

  def index
  end

  def show
  end

  def create
    @plan = current_account.plans.build(params[:plan])
    @plan.copy_from(@copy_from, :copy => params[:copy_from][:elements]) if @copy_from

    if @plan.save
      flash[:notice] = t(:plan_successfully_created)
      respond_to do |format|
        # htmlunit does not seem to send any accept header set through xhr objects, 2.7. should fix this
        # http://sourceforge.net/tracker/?func=detail&aid=2862553&group_id=47038&atid=448266
        format.json { render :status => 201 }
      end
    else
      flash[:error] = t(:plan_could_not_be_created)
      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def update
    if @plan.update_attributes(params[:plan])
      flash[:notice] = t(:plan_successfully_updated)
      respond_to do |format|
        format.json { render :status => 200 }
      end
    else
      flash[:error] = t(:plan_could_not_be_updated)
      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def destroy
    @plan.destroy
    flash[:notice] = t(:plan_successfully_deleted)

    respond_to do |format|
      format.json { render :status => 200 }
    end
  end

  protected

    def set_plans
      @plans = current_account.plans
    end

    def set_templates
      @templates = current_account.plans.templates
    end

    def set_template
      id = params[:copy_from][:id] if params[:copy_from]
      @copy_from = current_account.plans.templates.find(id) unless id.blank?
    end

    def set_plan
      @plan = params[:id] ? current_account.plans.find(params[:id]) :
        Plan.new(:start => Time.zone.now.beginning_of_day + 8.hours,
                 :end   => Time.zone.now.beginning_of_day + 5.days + 18.hours)
    end

    def set_employees
      @employees = current_account.employees.active
    end

    def set_workplaces
      @workplaces = current_account.workplaces.active
    end

    def set_qualifications
      @qualifications = current_account.qualifications
    end
end
