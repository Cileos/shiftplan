class StatusesController < ApplicationController
  before_filter :set_employees, :only => :index
  before_filter :set_employee
  before_filter :set_statuses, :only => :index

  def index
  end

  def create
    @status = @employee.statuses.build(params[:status])

    if @status.save
      flash[:notice] = t(:status_successfully_created)
      redirect_to employee_statuses_url(@employee)
    else
      set_employees
      flash[:error] = t(:status_could_not_be_created)
      render :action => 'index'
    end
  end

  protected

    def set_employees
      @employees = Employee.all
    end

    def set_employee
      @employee = Employee.find(params[:employee_id]) if params[:employee_id]
    end

    def set_statuses
      @statuses = @employee.statuses.default.group_by(&:day_of_week).sort_by(&:first) if @employee
    end
end
