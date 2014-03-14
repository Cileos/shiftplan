# The SchedulingFilter helps to scope the selected Schedulings to the
# selected date range. It represents a week view of the plan for
# display in a weekly calendar. It behaves like an ActiveRecord model
# and can therefor be used in forms to build searches.
class SchedulingFilter < RecordFilter

  class CannotFindMonday < RuntimeError; end

  attribute :plan
  attribute :week, type: Integer
  attribute :day, type: Integer
  attribute :month, type: Integer
  attribute :year, type: Integer
  attribute :cwyear, type: Integer
  attribute :ids #, type: Array # TODO Array cannot be typecasted yet by AA

  def base
    self.class.name.gsub('Filter', '').constantize
  end

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

  def first_day
    if week?
      monday
    else
      date
    end
  end

  def starts_at
    first_day.beginning_of_day
  end

  def ends_at
    last_day.end_of_day
  end

  def last_day
    if week?
      Date.commercial(cwyear, week, 7)
    else
      date.to_time
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

  def records
    sorted_records
  end

  def sorted_records
    @sorted_records ||= sort_fields.inject(unsorted_records) { |records, field| records.sort_by(&field) }
  end

  def unsorted_records
    fetch_records
  end

  def period
    @period ||= plan.period
  end

  def outside_plan_period?(date)
    before_start_of_plan?(date) || after_end_of_plan?(date)
  end

  def before_start_of_plan?(date=last_day)
    period.starts_after_date?(date)
  end

  def after_end_of_plan?(date=first_day)
    period.ends_before_date?(date)
  end

  def without(*unwanted)
    self.class.new attributes.except(*unwanted.map(&:to_s))
  end

  private
    def fetch_records
      results = base
      results = results.where(conditions)
      results = results.between( starts_at, ends_at )
      results = results.includes(*to_include)
      results = results.includes(:plan => { :organization => :account })
      results
    end

    def to_include
      [:employee, :team, :previous_day, :next_day]
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
