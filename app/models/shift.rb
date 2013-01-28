require_dependency 'with_previous_changes_undone'

class Shift < ActiveRecord::Base
  include WithPreviousChangesUndone

  belongs_to :plan_template
  belongs_to :team
  has_many   :demands, through: :demands_shifts
  has_many   :demands_shifts, class_name: 'DemandsShifts', dependent: :destroy

  accepts_nested_attributes_for :demands, reject_if: :all_blank, allow_destroy: true

  attr_accessible :start_hour, :end_hour, :start_minute, :end_minute, :day, :team_id, :demands_attributes

  validates :plan_template, :team, :day, :start_hour, :end_hour, :start_minute, :end_minute,
    presence: true
  validates :start_hour, :inclusion => { :in => 0..23 }
  validates :end_hour,   :inclusion => { :in => 0..24 }
  validates :start_minute, :end_minute, :inclusion => { :in => [0,15,30,45] }
  validates_with ShiftPeriodValidator

  attr_accessor :next_day
  attr_reader :next_day_end_hour
  attr_reader :next_day_end_minute

  before_validation :set_end_of_nightshift_to_midnight
  after_save :create_next_day

  def self.filter(params={})
    ShiftFilter.new params.reverse_merge(:base => self)
  end

  def concurrent
    ShiftFilter.new plan_template: plan_template
  end

  def set_end_of_nightshift_to_midnight
    if end_hour && start_hour && end_hour < start_hour # overnight shift
      @next_day_end_hour = end_hour
      @next_day_end_minute = end_minute
      self.end_hour = 24
      self.end_minute = 0
    end
  end

  private

  def over_midnight_shift?
    next_day_end_hour.present?
  end

  # if an hour range spanning over midnight is given, we split the shift. the second part is created here
  def create_next_day
    if over_midnight_shift?
      next_day_end_hour = @next_day_end_hour
      next_day_end_minute = @next_day_end_minute
      @next_day_end_hour = nil # must be cleared to protect it from dupping
      @next_day_end_minute = nil # must be cleared to protect it from dupping
      self.next_day = dup.tap do |next_day|
        next_day.day = day + 1
        next_day.start_hour = 0
        next_day.start_minute = 0
        next_day.end_hour = next_day_end_hour
        next_day.end_minute = next_day_end_minute
        next_day.save!
        demands.each do |d|
          next_day.demands << d
        end
      end
    end
  end
end

ShiftDecorator
