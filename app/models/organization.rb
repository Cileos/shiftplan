class Organization < ActiveRecord::Base
  belongs_to :planner, :class_name => 'User'
  has_many :employees, order: 'created_at DESC'
  has_many :plans
end
