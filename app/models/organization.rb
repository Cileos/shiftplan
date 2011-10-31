class Organization < ActiveRecord::Base
  belongs_to :planer, :class_name => 'User'
  has_many :employees
end
