class EmployeesController < ApplicationController
  before_filter :set_employees, :only => :index
  before_filter :set_employee, :only => [:show, :new, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :layout => !request.xhr? }
      format.csv do
        file = Tempfile.new('employees.csv')
        file << if params[:blank].present?
          Employee.csv_fields.to_csv(:col_sep => ';')
        else
          @employees.to_csv(:col_sep => ';')
        end
        file.close

        send_file(file.path, :type => :csv, :stream => false)
      end
    end
  end

  def new
    render :layout => !request.xhr?
  end

  def import
  end

  def create
    @employee = current_account.employees.build(params[:employee])
    if @employee.save
      flash[:notice] = t(:employee_successfully_created)
      respond_to do |format|
        # htmlunit does not seem to send any accept header set through xhr objects, 2.7. should fix this
        # http://sourceforge.net/tracker/?func=detail&aid=2862553&group_id=47038&atid=448266
        format.json { render :status => 201 }
      end
    else
      flash[:error] = t(:employee_could_not_be_created)
      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def upload
    number_of_imported_employees = current_account.import_employees_from_file(params[:file])
    flash[:notice] = t(:employee_could_not_be_created)
    redirect_to employees_url
  end

  def edit
    render :layout => !request.xhr?
  end

  def update
    if @employee.update_attributes(params[:employee])
      flash[:notice] = t(:employee_successfully_updated)
      respond_to do |format|
        format.json { render :status => 200 }
      end
    else
      flash[:error] = t(:employee_could_not_be_updated)
      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def destroy
    @employee.destroy
    flash[:notice] = t(:employee_successfully_deleted)
    respond_to do |format|
      format.json { render :status => 200 }
    end
  end

  private

    def set_employees
      @employees = current_account.employees
    end

    def set_employee
      @employee = params[:id] ? current_account.employees.find(params[:id]) : current_account.employees.build
    end
end
