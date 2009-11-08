class DefaultAvailabilitiesController < ApplicationController
  before_filter :set_employees, :only => :index
  before_filter :set_employee

  def index
  end

  def create
    @default_availability = @employee.default_availabilities.build(params[:default_availability])

    if @default_availability.save
      flash[:notice] = t(:default_availability_successfully_created)
      redirect_to employee_default_availabilities_url(@employee)
    else
      flash[:error] = t(:default_availability_could_not_be_created)
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
end
