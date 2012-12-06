class ShiftTeamsInWeekDecorator < ApplicationDecorator

  delegate :organization, to: :plan_template

  def formatted_days
    days.map do |day|
      [
        I18n.localize(day, format: :week_day),      # day
        I18n.localize(day, format: :abbr_week_day)  # abbr
      ]
    end
  end

  def days
    (1..7).to_a.map do |number|
      day_at(number)
    end
  end

  def day_at(offset)
    monday + (offset.to_i - 1 ).days
  end

  def monday
    Date.today.beginning_of_week
  end

  def teams
    organization.teams
  end

  def plan_template
    model
  end

  def table_metadata
    {
      new_url: h.new_account_organization_plan_template_shift_path(h.current_account,
        h.current_organization, plan_template)
    }
  end

  def render_cell_for_day(day, *a)
    options = a.extract_options!
    options[:data] = cell_metadata(day, *a)

    h.content_tag :td, cell_content(day, *a), options
  end

  def cell_metadata(day, team)
    { :'team-id' => team.id, :day => day }
  end

  # TODO: implement
  def find_shifts(*a)
    []
  end

  def cell_content(*a)
    shifts = find_shifts(*a)
    unless shifts.empty?
      h.render "shifts/lists/teams_in_week", shifts: shifts.map(&:decorate), filter: self
    end
  end
end

