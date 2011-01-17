pdf.text "Plan: #{@plan.name}", :size => 18
pdf.text t(:plan_from_to, :start_date => l(@plan.start_date), :end_date => l(@plan.end_date))

@plan.days.each do |day|
  pdf.pad_top 20 do
    pdf.text l(day, :format => "%A, %d. %B %y")

    shifts = Array(@plan.shifts.by_day[day])
    data = shifts.group_by(&:workplace).collect do |workplace, shifts|
      shifts.map! do |shift|
        from_to = t(:plan_from_to, :start_date => l(shift.start, :format => :time), :end_date => l(shift.end, :format => :time))
        employees = shift.requirements.map(&:assignee_and_qualification).compact.join(', ')
        "#{from_to}: #{employees.present? ? employees : t(:nobody)}"
      end
      [workplace.name, shifts.join("\n")]
    end

    if data.present?
      pdf.table data, :border_style => :grid
    else
      pdf.text t(:no_shifts_for_this_day)
    end
  end
end
