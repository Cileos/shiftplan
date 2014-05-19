module SchedulingCreationSpecHelper
  # use factory except for the time range related attributes, so the
  # validity of the Scheduling is not compromised
  def build_without_dates(attrs={})
    build :scheduling, attrs.reverse_merge({
      starts_at: nil,
      ends_at:   nil,
      week:      nil,
      year:      nil,
      date:      nil
    })
  end

  def s(quickie, employee, extra={})
    create :scheduling_by_quickie, extra.reverse_merge(quickie: quickie, employee: employee)
  end

  def una(quickie, extra={})
    create :unavailability_by_quickie, extra.reverse_merge(quickie: quickie)
  end
end

RSpec.configure do |config|
  config.include SchedulingCreationSpecHelper
end
