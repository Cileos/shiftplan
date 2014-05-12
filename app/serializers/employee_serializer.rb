class EmployeeSerializer < ApplicationSerializer
  attributes :id, :name

  has_one :account, ember: :objects
end
