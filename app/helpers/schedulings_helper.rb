module SchedulingsHelper
  def select_cell_in_calendar(scheduling)
    %Q~#calendar tbody td[data-employee_id=%s][data-day=%s]~ % [scheduling.employee_id, scheduling.day]
  end
end
