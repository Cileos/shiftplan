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

  attr_reader :next_day_end_hour
  attr_reader :next_day_end_minute

  before_validation :prepare_overnight_shift, if: :has_overnight_timespan?
  after_save        :create_or_update_next_day!
  after_destroy     :destroy_next_day, if: :next_day

  def self.filter(params={})
    ShiftFilter.new params.reverse_merge(:base => self)
  end

  def concurrent
    ShiftFilter.new plan_template: plan_template
  end

  def prepare_overnight_shift
    @next_day_end_hour = end_hour
    @next_day_end_minute = end_minute
    self.end_hour = 24
    self.end_minute = 0
  end

  def is_overnight?
    next_day || previous_day
  end

  def init_overnight_shift
    self.end_hour   = next_day.end_hour
    self.end_minute = next_day.end_minute
  end

  private

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
      next_day = create_next_day!
      link_to_next_day(next_day)
    end
  end

  def update_or_destroy_next_day!
    if has_overnight_timespan?
      update_next_day!
    else
      next_day.destroy
    end
  end

  def update_next_day!
    @has_overnight_timespan = false
    next_day.tap do |next_day|
      next_day.end_hour   = @next_day_end_hour
      next_day.end_minute = @next_day_end_minute
      next_day.team       = team
      next_day.day        = day + 1
      next_day.save!
      demands.select { |d| !next_day.demands.include?(d) }.each do |d|
        next_day.demands << d
      end
      # destroyed demands
      # TODO: refactor
      next_day.demands.select { |d| !demands.include?(d) }.each do |d|
        d.demands_shifts.find_by_shift_id(next_day.id).destroy
      end
    end
  end


  def create_next_day!
    @has_overnight_timespan = false
    next_day_end_hour = @next_day_end_hour
    next_day_end_minute = @next_day_end_minute
    @next_day_end_hour = nil # must be cleared to protect it from dupping
    @next_day_end_minute = nil # must be cleared to protect it from dupping
    next_day = dup.tap do |next_day|
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

  def link_to_next_day(next_day)
    self.next_day_id  = next_day.id
    # Save without callbacks, otherwise we will execute callback create_or_update_next_day
    # 2 times for the nightshift, leading to wrong results.
    # TODO: Rather set an instance variable which signals skipping the callback???
    save_without_callback!
  end

  def save_without_callback!
    self.class.skip_callback(:save, :after, :create_or_update_next_day!)
    save!
    self.class.set_callback(:save, :after, :create_or_update_next_day!)
  end

end

ShiftDecorator
