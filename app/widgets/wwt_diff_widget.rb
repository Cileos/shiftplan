class WwtDiffWidget < Struct.new(:filter, :row_record, :records)

  delegate :h, to: :filter

  def to_html
    h.abbr_tag(short_label_text,
               long_label_text,
               class: "badge #{label_class}")
  end

  def short_label_text(opts={})
    if wwt?
      if additional_hours?
        "#{human hours} (+#{human additional_hours}) / #{wwt.to_i}"
      else
        "#{human hours} / #{wwt.to_i}"
      end
    else
      if additional_hours?
        "#{human hours} (+#{human additional_hours})"
      else
        "#{human hours}"
      end
    end
  end

  def long_label_text(opts={})
    if wwt?
      if additional_hours?
        t 'long_label_with_adds_and_wwt', wwt: wwt.to_i, hours: human(hours), additional_hours: human(additional_hours)
      else
        t 'long_label', wwt: wwt.to_i, hours: human(hours)
      end
    else
      if additional_hours?
        t 'long_label_with_adds', hours: human(hours), additional_hours: human(additional_hours)
      else
        "#{human hours}"
      end
    end

  end

  # hours in this calendar (week)
  def hours
    raise NotImplementedError
  end

  # hours in all plans of the same account in the week described y filter
  def all_hours
    raise NotImplementedError
  end

  def additional_hours
    all_hours - hours
  end

  def human(numeric_hours)
    Volksplaner::Formatter.human_hours numeric_hours
  end

  # the 'badge-normal' class is not actually used by bootstrap, but we cannot test for absent class
  def label_class
    return 'badge-normal' unless wwt?
    difference = wwt - all_hours
    if difference > 0
      'badge-warning'
    elsif difference < 0
      'badge-important'
    else
      'badge-success'
    end
  end

  private

  def additional_hours?
    additional_hours.present? && additional_hours > 0
  end

  def wwt?
    false
  end

  def t(key, opts={})
    I18n.translate key, opts.merge(scope: 'widgets.wwt')
  end

end
