class StatusesController < ApplicationController
  before_filter :set_date_fields
  before_filter :set_employees
  before_filter :set_employee
  before_filter :set_statuses, :only => :index
  before_filter :set_status,   :only => :update

  def index
  end

  def create
    @status = Status.new(params[:status])

    if @status.save
      flash[:notice] = t(:status_successfully_created)
      respond_to do |format|
        format.json { render :template => 'statuses/success', :status => 201 }
      end
    else
      flash[:error] = t(:status_could_not_be_created)
      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  def update
    if @status.update_attributes(params[:status])
      flash[:notice] = t(:status_successfully_updated)
      respond_to do |format|
        format.json { render :template => 'statuses/success', :status => 200 }
      end
    else
      flash[:error] = t(:status_could_not_be_updated)
      respond_to do |format|
        format.json { render :template => 'shared/errors', :status => 400 }
      end
    end
  end

  protected

    def set_date_fields
      @year  = params[:year].to_i  || Date.current.year
      @month = params[:month].to_i || Date.current.month
      if params[:week]
        @week = params[:week].to_i
        @days = Date.week(@year, @week)
      end
    end

    def set_employees
      @employees = Employee.all
    end

    def set_employee
      @employee = Employee.find(params[:employee_id]) if params[:employee_id]
    end

    def set_statuses
      @statuses = @employee.statuses.override.group_by(&:day).sort_by(&:first) if @employee
    end

    def set_status
      @status = Status.find(params[:id])
    end
end
