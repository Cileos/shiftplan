class WwtDiffWidget < Struct.new(:h, :employee, :records)

  def to_html
    h.abbr_tag(label_text(short: true),
               label_text,
               class: "badge #{label_class}")
  end

  # TODO i18n 'of'
  def label_text(opts={})
    if employee.weekly_working_time.present?
      txt = opts[:short] ? '/' : 'of'
      "#{human_hours} #{txt} #{employee.weekly_working_time.to_i}"
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
    return 'badge-normal' unless employee.weekly_working_time.present?
    difference = employee.weekly_working_time - hours
    if difference > 0
      'badge-warning'
    elsif difference < 0
      'badge-important'
    else
      'badge-success'
    end
  end

end