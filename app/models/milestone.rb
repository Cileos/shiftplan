class Milestone < ActiveRecord::Base
  belongs_to :plan
  has_many :tasks, dependent: :destroy
  include Doable
end
