class AvailabilitiesController < ApplicationController
  before_filter :set_employees, :only => :index
  before_filter :set_employee
  before_filter :set_availabilities, :only => :index

  def index
  end

  def create
    @availability = @employee.availabilities.build(params[:availability])

    if @availability.save
      flash[:notice] = t(:availability_successfully_created)
      redirect_to employee_availabilities_url(@employee)
    else
      set_employees
      flash[:error] = t(:availability_could_not_be_created)
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

    def set_availabilities
      @availabilities = @employee.availabilities.default.group_by(&:day_of_week).sort_by(&:first) if @employee
    end
end
