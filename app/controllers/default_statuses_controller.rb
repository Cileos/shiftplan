class DefaultStatusesController < ApplicationController
  before_filter :set_employees
  before_filter :set_employee
  before_filter :set_default_statuses, :only => :index
  before_filter :set_default_status, :only => [:edit, :update, :destroy]

  def index
  end

  def new
    @default_status = @employee.statuses.build(params[:status])
  end

  def create
    @default_status = @employee.statuses.build(params[:status])

    if @default_status.save
      flash[:notice] = t(:default_status_successfully_created)
      redirect_to employee_default_statuses_url(@employee)
    else
      set_employees
      flash[:error] = t(:default_status_could_not_be_created)
      render :action => 'index'
    end
  end

  def edit
  end

  def update
    if @default_status.update_attributes(params[:status])
      flash[:notice] = t(:default_status_successfully_updated)
      redirect_to employee_default_statuses_url(@employee)
    else
      flash[:error] = t(:default_status_could_not_be_updated)
      render :action => 'edit'
    end
  end

  protected

    def set_employees
      @employees = Employee.all
    end

    def set_employee
      @employee = Employee.find(params[:employee_id]) if params[:employee_id]
    end

    def set_default_statuses
      @default_statuses = @employee.statuses.default.group_by(&:day_of_week).sort_by(&:first) if @employee
    end

    def set_default_status
      @default_status = @employee.statuses.default.find(params[:id]) if @employee
    end
end
