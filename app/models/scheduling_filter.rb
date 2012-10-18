# The SchedulingFilter helps to scope the selected Schedulings to the
# selected date range. It represents a week view of the plan for
# display in a weekly calendar. It behaves like an ActiveRecord model
# and can therefor be used in forms to build searches.
class SchedulingFilter
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::AttributeDefaults
  include Draper::ModelSupport

  attribute :plan
  attribute :base, default: Scheduling
  attribute :week, type: Integer
  attribute :day, type: Integer
  attribute :month, type: Integer
  attribute :year, type: Integer
  attribute :ids #, type: Array # TODO Array cannot be typecasted yet by AA

  delegate :count, to: :base

  def range
    if week?
      :week
    elsif date?
      :day
    else
      nil
    end
  end

  # OPTIMIZE is this always right? NiklasOffByOne?
  def monday
    ( Date.new(year) + week.weeks ).beginning_of_week
  end

  alias first_day monday

  def last_day
    ( Date.new(year) + week.weeks ).end_of_week
  end

  def previous_week
    prev = monday.prev_week
    self.class.new attributes.merge(week: prev.cweek, year: prev.year)
  end

  # list of Dates over wich the SchedulingFilter spans
  def days
    (1..duration_in_days).to_a.map do |number|
      day_at(number)
    end
  end

  # Number of days
  def duration_in_days
    case range
    when :week
      7
    else
      length_of_month # TODO month
    end
  end

  # the Date `offset` days from #monday. 1-based
  def day_at(offset)
    monday + (offset.to_i - 1 ).days
  end

  def date?
    day? and month? and year?
  end

  def date
    DateTime.civil_from_format(:utc, year, month, day)
  end

  # These _are_ the Schedulings you are looking for
  def records
    @records ||= fetch_records
  end

  delegate :all, to: :records

  def before_start_of_plan?(date=last_day)
    plan.starts_at.present? && date.to_date < plan.starts_at.to_date
  end

  def after_end_of_plan?(date=first_day)
    plan.ends_at.present? && date.to_date > plan.ends_at.to_date
  end


  private
    def fetch_records
      base.where(conditions).includes(:employee, :team).sort_by(&:start_hour)
    end

    def conditions
      case range
      when :week
        attributes.symbolize_keys.slice(:week, :year).reject {|_,v| v.nil? }.tap do |c|
          if plan?
            c.merge!(:plan_id => plan.id)
          end
          if ids? && !ids.empty?
            c.merge!(:id => ids)
          end
        end
      when :day
        raise ArgumentError, "not enough data to build date" unless date?
        ["starts_at::date = ?::date", date]
      end
    end


end
