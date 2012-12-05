class Shift < ActiveRecord::Base
  belongs_to :plan_template
  belongs_to :team

  validates :plan_template, :team, :start_hour, :end_hour, :start_minute, :end_minute,
    presence: true
  validates :start_hour,   :end_hour,   :inclusion => { :in => 0..23 }
  validates :start_minute, :end_minute, :inclusion => { :in => 0..59 }
end
