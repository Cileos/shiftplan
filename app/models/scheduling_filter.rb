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
  attribute :year, type: Integer, default: proc { Date.today.year }

  delegate :count, to: :base

  def range
    if week?
      :week
    else
      nil
    end
  end

  # OPTIMIZE is this always right? NiklasOffByOne?
  def first_day
    ( Date.new(year) + week.weeks ).beginning_of_week
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

  # the Date `offset` days from #first_day. 1-based
  def day_at(offset)
    first_day + (offset.to_i - 1 ).days
  end

  # These _are_ the Schedulings you are looking for
  def records
    base.where attributes.slice(:week, :year)
  end

  # looks up the index, savely
  def indexed(day, employee)
    if at_day = index[day.cwday]
      if at_day.key?(employee)
        at_day[employee]
      else
        []
      end
    else
      []
    end
  end

  # Returns a Hash of Hashes of Arrays
  #
  #   scheduling.cwday => scheduling.employee => []
  #
  def index
    @index ||= index_records
  end

  private
    def index_records
      records.group_by(&:cwday).map do |day, concurrent|
        { day => concurrent.group_by(&:employee) }
      end.inject(&:merge) || {}
    end


end
