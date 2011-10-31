class Organization < ActiveRecord::Base
  belongs_to :planer, :class_name => 'User'
end
