class SchedulingDecorator < ApplicationDecorator
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
    { quickie: quickie, id: id }
  end

  def concat(*args)
    args.compact.join(' ')
  end

  def insert_new_form
    append_modal body: h.render('new_form', scheduling: model)
  end


  private
    def scheduling
      model
    end
end
