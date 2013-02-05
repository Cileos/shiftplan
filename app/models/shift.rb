require_dependency 'with_previous_changes_undone'

class Shift < ActiveRecord::Base
  include WithPreviousChangesUndone
  include TimeRangeComponentsAccessible
  include Overnightable

  belongs_to :plan_template
  belongs_to :team
  has_many   :demands

  accepts_nested_attributes_for :demands, reject_if: :all_blank, allow_destroy: true

  attr_accessible :start_hour,
                  :end_hour,
                  :start_minute,
                  :end_minute,
                  :day,
                  :team_id,
                  :demands_attributes

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

  protected

  def base_for_time_range_components
    Time.zone.parse('00:00')
  end
end

ShiftDecorator
