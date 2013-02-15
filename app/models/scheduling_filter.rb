# The SchedulingFilter helps to scope the selected Schedulings to the
# selected date range. It represents a week view of the plan for
# display in a weekly calendar. It behaves like an ActiveRecord model
# and can therefor be used in forms to build searches.
class SchedulingFilter < RecordFilter
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::AttributeDefaults
  include Draper::Decoratable

  class CannotFindMonday < RuntimeError; end

  attribute :plan
  attribute :week, type: Integer
  attribute :day, type: Integer
  attribute :month, type: Integer
  attribute :year, type: Integer
  attribute :cwyear, type: Integer
  attribute :ids #, type: Array # TODO Array cannot be typecasted yet by AA

  def range
    if week?
      :week
    elsif date?
      :day
    else
      nil
    end
  end

  def monday
    if week? && cwyear?
      Date.commercial(cwyear, week, 1)
    else
      raise CannotFindMonday, "attributes: #{attributes.inspect}"
    end
  end

  alias first_day monday

  def last_day
    if week?
      Date.commercial(cwyear, week,7)
    end
  end

  def previous_week
    prev = monday.prev_week
    self.class.new attributes.merge(week: prev.cweek, cwyear: prev.cwyear)
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

  def before_start_of_plan?(date=last_day)
    plan.starts_at.present? && date.to_date < plan.starts_at.to_date
  end

  def after_end_of_plan?(date=first_day)
    plan.ends_at.present? && date.to_date > plan.ends_at.to_date
  end

  def outside_plan_period?(date)
    before_start_of_plan?(date) || after_end_of_plan?(date)
  end


  private
    def fetch_records
      results = base
      results = results.where(conditions)
      if week?
        results = results.in_week(week)
        if cwyear?
          results = results.in_cwyear(cwyear)
        end
      else
        if year?
          results = results.in_year(year)
        end
      end
      results = results.includes(*to_include)
      sort_fields.each do |field|
        results = results.sort_by(&field)
      end
      results
    end

    def to_include
      [:employee, :team]
    end

    def sort_fields
      [:start_hour, :qualification_name]
    end

    def conditions
      case range
      when :week
        {}.tap do |c|
          if plan?
            c.merge!(:plan_id => plan.id)
          end
          if ids? && !ids.empty?
            c.merge!(:id => ids)
          end
        end
      when :day
        # FIXME this may not work thanks to timezones, see Scheduling.in_year
        raise ArgumentError, "not enough data to build date" unless date?
        ["starts_at::date = ?::date", date]
      end
    end

end
