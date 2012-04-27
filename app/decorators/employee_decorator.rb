class EmployeeDecorator < ApplicationDecorator
  include EmployeeBaseDecorator
  decorates :employee

  protected

  def resource
    employee
  end
end
