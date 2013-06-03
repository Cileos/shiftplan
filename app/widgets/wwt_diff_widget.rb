class WwtDiffWidget < Struct.new(:h, :employee, :records)

  def to_html
    h.abbr_tag(wwt_diff_label_text_for(employee, short: true),
               wwt_diff_label_text_for(employee),
               class: "badge #{wwt_diff_label_class_for(employee)}")
  end

  def wwt_diff_label_text_for(employee, opts={})
    if employee.weekly_working_time.present?
      opts[:short].present? ? txt = '/' : txt = 'of'
      "#{hours_for(employee)} #{txt} #{employee.weekly_working_time.to_i}"
    else
      "#{hours_for(employee)}"
    end
  end

  def hours_for(employee)
    records.select {|s| s.employee == employee }.sum(&:length_in_hours).to_i
  end

  # the 'badge-normal' class is not actually used by bootstrap, but we cannot test for absent class
  def wwt_diff_label_class_for(employee)
    return 'badge-normal' unless employee.weekly_working_time.present?
    difference = employee.weekly_working_time - hours_for(employee)
    if difference > 0
      'badge-warning'
    elsif difference < 0
      'badge-important'
    else
      'badge-success'
    end
  end

end
