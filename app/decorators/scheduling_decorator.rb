class SchedulingDecorator < ApplicationDecorator
  decorates :scheduling

  def long
    quickie
  end

  def short
    concat hour_range_quickie # , team_shortcut
  end

  def team_class
    if team
      h.dom_id(team)
    else
      'no-team'
    end
  end

  def metadata
    { quickie: quickie, id: id }
  end

  def concat(*args)
    args.compact.join(' ')
  end


  private
    def scheduling
      model
    end
end
