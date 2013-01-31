require_dependency 'with_previous_changes_undone'

class Shift < ActiveRecord::Base
  include WithPreviousChangesUndone

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

  before_validation :prepare_overnightable, if: :has_overnight_timespan?
  after_save        :create_or_update_next_day!, if: :overnight_processing_needed?
  after_destroy     :destroy_next_day, if: :next_day

  def self.filter(params={})
    ShiftFilter.new params.reverse_merge(:base => self)
  end

  def concurrent
    ShiftFilter.new plan_template: plan_template
  end

  def prepare_overnightable
    @next_day_end_hour = end_hour
    @next_day_end_minute = end_minute
    self.end_hour = 24
    self.end_minute = 0
  end

  def is_overnight?
    next_day || previous_day
  end

  def init_overnight_end_time
    self.end_hour   = next_day.end_hour
    self.end_minute = next_day.end_minute
  end

  protected

  def overnight_processing_needed?
    !overnightable_processed? && (next_day || has_overnight_timespan?)
  end

  def overnightable_processed?
    @overnightable_processed
  end

  def update_demands
    add_demands
    destroy_demands
  end

  def add_demands
    added_demands.each do |demand|
      demands << demand
    end
  end

  def added_demands
    previous_day.demands.select { |demand| demands.exclude?(demand) }
  end

  def destroy_demands
    destroyed_demands.each do |demand|
      demand.destroy
    end
  end

  def destroyed_demands
    demands.select { |demand| previous_day.demands.exclude?(demand) }
  end

  def destroy_next_day
    next_day.destroy
  end

  def has_overnight_timespan?
    @has_overnight_timespan ||= end_hour && start_hour && end_hour < start_hour
  end

  # if an hour range spanning over midnight is given, we split the shift. the second part is created here
  def create_or_update_next_day!
    if next_day.present?
      update_or_destroy_next_day!
    elsif has_overnight_timespan?
      create_next_day!
    end
  end

  def update_or_destroy_next_day!
    if has_overnight_timespan?
      update_next_day!
    else
      destroy_next_day
    end
  end

  def update_next_day!
    next_day.tap do |next_day|
      next_day.end_hour   = @next_day_end_hour
      next_day.end_minute = @next_day_end_minute
      next_day.team       = team
      next_day.day        = day + 1
      next_day.save!
      next_day.update_demands
    end
  end

  def create_next_day!
    @has_overnight_timespan = nil # clear to protect it from duping
    self.next_day = dup.tap do |next_day|
      next_day.day = day + 1
      next_day.start_hour = 0
      next_day.start_minute = 0
      next_day.end_hour = @next_day_end_hour
      next_day.end_minute = @next_day_end_minute
      next_day.save!
      demands.each do |d|
        next_day.demands << d
      end
    end
    @overnightable_processed = true
    begin
      save!
    ensure
      @overnightable_processed = false
    end
  end
end

ShiftDecorator
