class Organization < ActiveRecord::Base
  belongs_to :planner, :class_name => 'User'
  has_many :employees
  has_many :plans
end
