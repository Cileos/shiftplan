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
end

