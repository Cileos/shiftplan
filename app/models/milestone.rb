class Milestone < ActiveRecord::Base
  belongs_to :plan
  has_many :tasks, dependent: :destroy
  include Doable

  belongs_to :responsible, class_name: 'Employee', foreign_key: :responsible_id

  attr_accessible :responsible_id
end
