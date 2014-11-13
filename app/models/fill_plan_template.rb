class FillPlanTemplate
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::AttributeDefaults

  attribute :template
  attribute :plan_id
  attribute :week
  attribute :year

  def source_schedulings_count
    if plan
      records.count
    else
      0
    end
  end

  def plan
    if plan_id.present?
      @plan ||= Plan.find(plan_id)
    end
  end

  def fill!
    Shift.transaction do
      fill_from_records records.to_a
    end
  end

  def filter
    @filter = Scheduling.filter(
      strict: true,
      plan: plan,
      week: week,
      cwyear: year
    )
  end

  def records
    # shifts need teams
    # need order to be deterministic for tests
    filter.unsorted_records.where('team_id IS NOT NULL').reorder('created_at')
  end

private

  def fill_from_records(records)
    records.group_by { |r| r.starts_at.to_date }.each do |_begin, same_day|
      same_day.group_by(&:period).each do |_period, same_time|
        same_time.group_by(&:team).each do |team, same_team|
          demands = same_team.group_by(&:qualification).map do |quali, same_quali|
            Demand.new(qualification: quali, quantity: same_quali.length)
          end
          s = same_team.first # lead by example
          template.shifts.create!(
            team: team,
            demands: demands,
            all_day: s.all_day,
            day: day_from_start_of_week(s.starts_at),
            start_hour: s.start_hour,
            start_minute: s.start_minute,
            end_hour: s.end_hour,
            end_minute: s.end_minute,
          )
        end
      end
    end
  end

  def start_of_week
    @start_of_week ||= Date.commercial(year, week, 1).in_time_zone
  end

  def day_from_start_of_week(time)
    ((time - start_of_week) / (60*60*24)).floor
  end
end

