class Location < ActiveRecord::Base
  has_many :workplaces

  default_scope :order => "name ASC"
end
