class Shift < ActiveRecord::Base
  include WithPreviousChangesUndone
  include TimeRangeComponentsAccessible
  include AllDaySettable
  include Overnightable

  belongs_to :plan_template
  belongs_to :team
  has_many   :demands, -> { order('id') }

  accepts_nested_attributes_for :demands, reject_if: :all_blank, allow_destroy: true

  validates :plan_template,
            :team,
            :day,
            :start_hour,
            :end_hour,
            :start_minute,
            :end_minute,
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

  # Delegate the demands of the second day of a nightshift to the previous day.
  def demands_with_respecting_previous_day
    if previous_day.present?
      previous_day.demands
    else
      demands_without_respecting_previous_day
    end
  end
  alias_method_chain :demands, :respecting_previous_day

  # we store the times as UTC and just pick hours&minute from it
  def starts_at
    read_attribute(:starts_at)
  end

  def starts_at=(time_with_zone)
    write_attribute :starts_at, time_with_zone.utc.beginning_of_day + time_with_zone.hour.hours + time_with_zone.min.minutes
  end

  def ends_at
    if utc = read_attribute(:ends_at)
      utc = utc.tomorrow if utc < starts_at
      utc
    end
  end

  def ends_at=(time_with_zone)
    write_attribute :ends_at, time_with_zone.utc.beginning_of_day + time_with_zone.hour.hours + time_with_zone.min.minutes
  end

  protected

  # we are only interested in the time component, so always treat the time like they would be TODAY
  def base_for_time_range_components
    Time.current.beginning_of_day
  end
end

ShiftDecorator
