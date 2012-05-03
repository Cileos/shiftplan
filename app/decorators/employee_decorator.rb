class EmployeeDecorator < ApplicationDecorator
  include EmployeeBaseDecorator
  decorates :employee
end