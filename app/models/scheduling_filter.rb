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
  attribute :year, type: Integer
  attribute :ids #, type: Array # TODO Array cannot be typecasted yet by AA

  delegate :count, to: :base

  def range
    if week?
      :week
    else
      nil
    end
  end

  # OPTIMIZE is this always right? NiklasOffByOne?
  def monday
    ( Date.new(year) + week.weeks ).beginning_of_week
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

  # These _are_ the Schedulings you are looking for
  def records
    @records ||= fetch_records
  end

  delegate :all, to: :records

  # looks up the index, savely
  def indexed(day, employee)
    if at_day = index[day.iso8601]
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
  #   scheduling.day(iso8601) => scheduling.employee => []
  #
  def index
    @index ||= index_records
  end

  private
    def index_records
      records.group_by(&:iso8601).map do |day, concurrent|
        { day => concurrent.group_by(&:employee) }
      end.inject(&:merge) || {}
    end

    def fetch_records
      base.where(conditions).includes(:employee, :team)
    end

    def conditions
      attributes.symbolize_keys.slice(:week, :year).reject {|_,v| v.nil? }.tap do |c|
        if plan?
          c.merge!(:plan_id => plan.id)
        end
        if ids? && !ids.empty?
          c.merge!(:id => ids)
        end
      end
    end


end
