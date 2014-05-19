module SchedulableDecoratorHelper
  def team_class
    if team
      dom_id(team)
    else
      'no-team'
    end
  end

  def work_time(extra_class=nil)
    klass = "work_time #{extra_class}"
    if all_day?
      h.content_tag :span, I18n.translate('all_day', scope: 'simple_form.labels.defaults'), class: klass
    else
      h.abbr_tag period_with_zeros, period_with_duration, class: klass
    end
  end

  def css_class
    concat nightshift_class, team_class
  end

  def concat(*args)
    args.compact.join(' ')
  end
end
