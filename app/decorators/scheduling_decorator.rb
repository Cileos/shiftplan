class SchedulingDecorator < RecordDecorator
  include TimePeriodFormatter
  include OvernightableDecoratorHelper
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
    super.merge({
      start: start_hour,
      length: length_in_hours
    })
  end

  def concat(*args)
    args.compact.join(' ')
  end

  def edit_url
    edit_url_for_overnightable
  end


  private
  def scheduling
    source
  end
end
