class Scheduling < ActiveRecord::Base
  belongs_to :plan
  belongs_to :employee

  attr_accessor :day, :quicky
end
