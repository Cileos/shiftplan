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

      respond_to do |format|
        format.html { redirect_to employees_url }
        # render :json => "{ 'flash': { 'notice': '#{flash[:notice]}' }, 'schools': [#{schools.map { |school| school.to_json(:only => [:id, :title], :include => { :city => { :only => :title }, :region => { :only => :title } }) }.join(', ')}]}"
        format.json { render :text => 'OK', :status => 201 }
      end
    else
      flash[:error] = 'Employee could not be created.'

      respond_to do |format|
        format.html { render :action => 'new' }
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def edit
    render :layout => !request.xhr?
  end

  def update
    if @employee.update_attributes(params[:employee])
      flash[:notice] = 'Employee successfully updated.'

      respond_to do |format|
        format.html { redirect_to employees_url }
        format.json { render :text => 'OK', :status => 200 }
      end
    else
      flash[:error] = 'Employee could not be updated.'

      respond_to do |format|
        format.html { render :action => 'edit', :layout => !request.xhr? }
        format.json { render :template => 'shared/errors', :status => 400 }
      end
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
