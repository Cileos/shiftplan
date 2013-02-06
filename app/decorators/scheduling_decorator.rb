class SchedulingDecorator < RecordDecorator
  include TimePeriodFormatter
  decorates :scheduling

  def long
    quickie
  end

  def short
    concat hour_range_quickie, team_shortcut
  end

  def team_class
    if team
      dom_id(team)
    else
      'no-team'
    end
  end

  def nightshift_class
    if start_hour == 0
      'early'
    elsif end_hour == 24
      'late'
    end
  end

  def css_class
    concat nightshift_class, team_class
  end

  def team_shortcut
    if team
      team.shortcut
    end
  end

  def metadata
    {
      edit_url: edit_url,
      start: start_hour,
      length: length_in_hours
    }
  end

  def edit_url
    organization = scheduling.organization
    h.url_for([:edit, organization.account, organization, scheduling.plan, scheduling])
  end

  def concat(*args)
    args.compact.join(' ')
  end


  private
    def scheduling
      model
    end
end
