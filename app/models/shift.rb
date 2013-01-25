require_dependency 'with_previous_changes_undone'

class Shift < ActiveRecord::Base
  include WithPreviousChangesUndone

  belongs_to :plan_template
  belongs_to :team
  has_many   :demands

  accepts_nested_attributes_for :demands, reject_if: :all_blank, allow_destroy: true

  attr_accessible :start_hour, :end_hour, :start_minute, :end_minute, :day, :team_id, :demands_attributes

  # TODO: comment in again, when our scheduling support minutes, too
  validates :plan_template, :team, :day, :start_hour, :end_hour, :start_minute, :end_minute,
    presence: true
  validates :start_hour,   :end_hour,   :inclusion => { :in => 0..23 }
  validates :start_minute, :end_minute, :inclusion => { :in => [0,15,30,45] }
  validates_with ShiftPeriodValidator


  def self.filter(params={})
    ShiftFilter.new params.reverse_merge(:base => self)
  end

  def concurrent
    ShiftFilter.new plan_template: plan_template
  end
end

ShiftDecorator
