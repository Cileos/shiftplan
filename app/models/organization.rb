class Organization < ActiveRecord::Base
  belongs_to :planer, :class_name => 'User'
  has_many :employees
  has_many :plans
end
