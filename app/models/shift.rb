require_dependency 'with_previous_changes_undone'

class Shift < ActiveRecord::Base
  include WithPreviousChangesUndone

  belongs_to :plan_template
  belongs_to :team
  has_many   :demands, through: :demands_shifts
  has_many   :demands_shifts, class_name: 'DemandsShifts', dependent: :destroy
  # TODO: association does not work
  has_one    :overnight_mate, class_name: 'Shift', foreign_key: 'overnight_mate_id'

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
  after_save :create_or_update_overnight_mates!

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
    overnight_mate_id
  end
  alias :has_overnight_mate? :is_overnight?

  private

  def set_overnight_timespan
    if first_day?
      self.end_hour   = overnight_mate.end_hour
      self.end_minute = overnight_mate.end_minute
    elsif second_day?
      self.start_hour   = overnight_mate.start_hour
      self.start_minute = overnight_mate.start_minute
    end
  end

  def first_day?
    is_overnight? && day < overnight_mate.day
  end

  def second_day?
    is_overnight? && day > overnight_mate.day
  end

  def has_overnight_timespan?
    @has_overnight_timespan ||= end_hour && start_hour && end_hour < start_hour
  end

  def update_overnight_mates!
    @has_overnight_timespan = false
    overnight_mate.tap do |mate|
      mate.end_hour = @next_day_end_hour
      mate.end_minute = @next_day_end_minute
      mate.save!
      demands.select { |d| !mate.demands.include?(d) }.each do |d|
        mate.demands << d
      end
    end
  end

  def create_overnight_mates!
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
      mate.overnight_mate = self
      mate.save!
      demands.each do |d|
        mate.demands << d
      end
    end
    self.overnight_mate  = mate
    save!
  end

  # if an hour range spanning over midnight is given, we split the shift. the second part is created here
  def create_or_update_overnight_mates!
    if has_overnight_mate?
      if has_overnight_timespan?
        update_overnight_mates!
      else
        # TODO: delete one of the mates
      end
    elsif has_overnight_timespan?
      create_overnight_mates!
    end
  end
end

ShiftDecorator
