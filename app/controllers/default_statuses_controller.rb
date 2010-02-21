class DefaultStatusesController < ApplicationController
  before_filter :set_employees
  before_filter :set_default_statuses, :only => :index

  def index
  end

  protected

    def set_employees
      @employees = Employee.all
    end

    def set_default_statuses
      @default_statuses = @employee.statuses.default.group_by(&:day_of_week).sort_by(&:first) if @employee
    end
end
