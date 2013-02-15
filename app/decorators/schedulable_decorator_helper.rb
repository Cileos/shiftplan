module SchedulableDecoratorHelper
  def team_class
    if team
      dom_id(team)
    else
      'no-team'
    end
  end

  def css_class
    concat nightshift_class, team_class
  end

  def concat(*args)
    args.compact.join(' ')
  end
end
