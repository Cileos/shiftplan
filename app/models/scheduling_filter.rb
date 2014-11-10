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

  delegate :organization, to: :plan

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
      Date.commercial(cwyear, week, 1).in_time_zone
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

  def predecessor
    prev = monday.prev_week
    self.class.new attributes.merge(week: prev.cweek, cwyear: prev.cwyear)
  end

  def successor
    nxt = monday.next_week
    self.class.new attributes.merge(week: nxt.cweek, cwyear: nxt.cwyear)
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
    monday.to_date + (offset.to_i - 1 ).days
  end

  def date?
    day? and month? and year?
  end

  def date
    DateTime.civil_from_format(:utc, year, month, day || 1)
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

  def employees
    organization.employees
                .default_sorting
  end

  def unavailabilities
    Unavailability.
      overlapping( starts_at, ends_at ).
      preload(:employee).
      where(employee_id: employees.map(&:id))
  end

  private
    def filtered_base
      super.overlapping( starts_at, ends_at )
    end

    def fetch_records
      results = filtered_base.preload(*to_preload)
      results = results.preload(:plan => { :organization => :account })
      results
    end

    def to_preload
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
