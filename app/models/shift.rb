require_dependency 'with_previous_changes_undone'

class Shift < ActiveRecord::Base
  include WithPreviousChangesUndone
  include TimeRangeComponentsAccessible
  include Overnightable

  belongs_to :plan_template
  belongs_to :team
  has_many   :demands

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

  def demands_with_respecting_next_day
    if next_day.present?
      next_day.demands
    else
      demands_without_respecting_next_day
    end
  end
  alias_method_chain :demands, :respecting_next_day

  protected

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

  def has_overnight_timespan?
    @has_overnight_timespan ||= end_hour && start_hour && end_hour < start_hour
  end

  def update_next_day
    next_day.tap do |next_day|
      tomorrow.day = day + 1
      tomorrow.ends_at = ends_at + 1.day
      tomorrow.team = team
      tomorrow.next_day = nil # prevents that a next day for the next day will be created
      tomorrow.save!
      tomorrow.update_demands
      self.ends_at = ends_at.end_of_day
    end
  end

  def build_and_save_next_day
    dup.tap do |next_day|
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
  end

  def base_for_time_range_components
    plan_template.created_at.beginning_of_day
  end
end

ShiftDecorator
