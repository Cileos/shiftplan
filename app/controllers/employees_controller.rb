class EmployeesController < ApplicationController
  before_filter :set_employees, :only => :index
  before_filter :set_employee, :only => [:show, :new, :edit, :update, :destroy]

  def index
    render :layout => !request.xhr?
  end

  def new
    render :layout => !request.xhr?
  end

  def create
    @employee = Employee.new(params[:employee])

    if @employee.save
      flash[:notice] = 'Employee successfully created.'
      redirect_to employees_url
    else
      flash[:error] = 'Employee could not be created.'
      render :action => "new", :layout => !request.xhr?
    end
  end

  def edit
    render :layout => !request.xhr?
  end

  def update
    if @employee.update_attributes(params[:employee])
      flash[:notice] = 'Employee successfully updated.'
      redirect_to employees_url
    else
      flash[:error] = 'Employee could not be updated.'
      render :action => "edit", :layout => !request.xhr?
    end
  end

  def destroy
    @employee.destroy
    flash[:notice] = 'Employee successfully deleted.'
    redirect_to employees_url
  end

  private

    def set_employees
      @employees = Employee.all
    end

    def set_employee
      @employee = params[:id] ? Employee.find(params[:id]) : Employee.new
    end
end
