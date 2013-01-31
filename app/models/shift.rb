require_dependency 'with_previous_changes_undone'

class Shift < ActiveRecord::Base
  include WithPreviousChangesUndone
  include Overnightable

  belongs_to :plan_template
  belongs_to :team
  has_many   :demands, through: :demands_shifts
  has_many   :demands_shifts, class_name: 'DemandsShifts', dependent: :destroy
  belongs_to :next_day, class_name: 'Shift'
  has_one    :previous_day, class_name: 'Shift', foreign_key: 'next_day_id'

  accepts_nested_attributes_for :demands, reject_if: :all_blank, allow_destroy: true

  attr_accessible :start_hour, :end_hour, :start_minute, :end_minute, :day, :team_id, :demands_attributes

  validates :plan_template, :team, :day, :start_hour, :end_hour, :start_minute, :end_minute,
    presence: true
  validates :start_hour, :inclusion => { :in => 0..23 }
  validates :end_hour,   :inclusion => { :in => 0..24 }
  validates :start_minute, :end_minute, :inclusion => { :in => [0,15,30,45] }
  validates_with ShiftPeriodValidator

  def self.filter(params={})
    ShiftFilter.new params.reverse_merge(:base => self)
  end

  def concurrent
    ShiftFilter.new plan_template: plan_template
  end

  def init_overnight_end_time
    self.end_hour   = next_day.end_hour
    self.end_minute = next_day.end_minute
  end

  protected

  def prepare_overnightable
    @next_day_end_hour = end_hour
    @next_day_end_minute = end_minute
    self.end_hour = 24
    self.end_minute = 0
  end
end

ShiftDecorator
