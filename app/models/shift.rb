require_dependency 'with_previous_changes_undone'

class Shift < ActiveRecord::Base
  include WithPreviousChangesUndone

  belongs_to :plan_template
  belongs_to :team
  has_many   :demands, through: :demands_shifts
  has_many   :demands_shifts, class_name: 'DemandsShifts', dependent: :destroy
  has_one    :next_day, class_name: 'Shift', foreign_key: 'id', primary_key: 'next_day_id'

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
  after_save :create_or_update_next_days!
  after_destroy :destroy_second_day, if: :first_day?

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
    first_day? || second_day?
  end

  def first_day?
    # TODO: why the hack does next_day.present? not work?
    next_day_id.present?
  end

  def second_day?
    first_day.present?
  end

  def first_day
    @first_day ||= if new_record?
      nil
    else
      Shift.find_by_next_day_id(id)
    end
  end

  def init_overnight_shift
    self.end_hour   = next_day.end_hour
    self.end_minute = next_day.end_minute
  end

  private

  def destroy_second_day
    next_day.destroy
  end

  def has_overnight_timespan?
    @has_overnight_timespan ||= end_hour && start_hour && end_hour < start_hour
  end

  def update_next_days!
    @has_overnight_timespan = false
    next_day.tap do |mate|
      mate.end_hour   = @next_day_end_hour
      mate.end_minute = @next_day_end_minute
      mate.team       = team
      mate.day        = day + 1
      mate.save!
      demands.select { |d| !mate.demands.include?(d) }.each do |d|
        mate.demands << d
      end
      # destroyed demands
      # TODO: refactor
      mate.demands.select { |d| !demands.include?(d) }.each do |d|
        d.demands_shifts.find_by_shift_id(mate.id).destroy
      end
    end
  end

  def create_next_days!
    @has_overnight_timespan = false
    next_day_end_hour = @next_day_end_hour
    next_day_end_minute = @next_day_end_minute
    @next_day_end_hour = nil # must be cleared to protect it from dupping
    @next_day_end_minute = nil # must be cleared to protect it from dupping
    mate = dup.tap do |mate|
      mate.day = day + 1
      mate.start_hour = 0
      mate.start_minute = 0
      mate.end_hour = next_day_end_hour
      mate.end_minute = next_day_end_minute
      mate.save!
      demands.each do |d|
        mate.demands << d
      end
    end
    self.next_day_id  = mate.id
    # Save without callbacks, otherwise we will execute callback create_or_update_next_days
    # 2 times for the nightshift, leading to wrong results.
    # Rather set an instance variable which signals skipping the callback???
    save_without_callback!
  end

  def save_without_callback!
    self.class.skip_callback(:save, :after, :create_or_update_next_days!)
    save!
    self.class.set_callback(:save, :after, :create_or_update_next_days!)
  end

  # if an hour range spanning over midnight is given, we split the shift. the second part is created here
  def create_or_update_next_days!
    if first_day?
      if has_overnight_timespan?
        update_next_days!
      else
        next_day.destroy
      end
    elsif has_overnight_timespan?
      create_next_days!
    end
  end
end

ShiftDecorator
