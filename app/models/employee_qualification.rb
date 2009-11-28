class EmployeeQualification < ActiveRecord::Base
  belongs_to :employee
  belongs_to :qualification

  validates_presence_of :employee_id,      :if => lambda { |record| record.employee.nil? }
  validates_presence_of :qualification_id, :if => lambda { |record| record.qualification.nil? }
end
