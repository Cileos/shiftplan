class EmployeeQualification < ActiveRecord::Base
  belongs_to :employee
  belongs_to :qualification
end
