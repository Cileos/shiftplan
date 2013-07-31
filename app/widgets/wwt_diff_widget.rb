class WwtDiffWidget < Struct.new(:h, :employee, :records)

  def to_html
    h.abbr_tag(short_label_text,
               long_label_text,
               class: "badge #{label_class}")
  end

  def short_label_text(opts={})
    if wwt?
      "#{human_hours} / #{wwt.to_i}"
    else
      "#{human_hours}"
    end
  end

  # TODO i18n 'of'
  def long_label_text(opts={})
    if wwt?
      t 'long_label', wwt: wwt.to_i, hours: human_hours
    else
      "#{human_hours}"
    end

  end

  def hours
    records.select {|s| s.employee == employee }.sum(&:length_in_hours)
  end

  def human_hours
    Volksplaner::Formatter.human_hours(hours)
  end

  # the 'badge-normal' class is not actually used by bootstrap, but we cannot test for absent class
  def label_class
    return 'badge-normal' unless wwt?
    difference = wwt - hours
    if difference > 0
      'badge-warning'
    elsif difference < 0
      'badge-important'
    else
      'badge-success'
    end
  end

  private

  def wwt
    employee.weekly_working_time
  end

  def wwt?
    employee.weekly_working_time.present?
  end

  def t(key, opts={})
    I18n.translate key, opts.merge(scope: 'widgets.wwt')
  end

end
