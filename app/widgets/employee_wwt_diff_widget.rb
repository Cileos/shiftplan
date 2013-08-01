class EmployeeWwtDiffWidget < WwtDiffWidget
  def employee
    row_record
  end

  # hours in this calendar (week)
  def hours
    @hours ||= records.select {|s| s.employee == employee }.sum(&:length_in_hours)
  end

  # hours in all plans of the same account in the week described y filter
  def all_hours
    @all_hours ||=
      filter.
      without(:plan).
      unsorted_records.
      where(employee_id: employee.id).
      to_a.
      sum(&:length_in_hours)
  end

  def wwt?
    employee.weekly_working_time.present?
  end

  def wwt
    employee.weekly_working_time
  end
end
