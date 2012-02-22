class Organization < ActiveRecord::Base
  belongs_to :planner, :class_name => 'User'
  has_many :employees, :order => 'last_name ASC, first_name ASC'
  has_many :plans
  has_many :teams, :order => 'name ASC'
end
