class SchedulingFilterDecorator < ApplicationDecorator
  decorates :scheduling_filter

  # The title of the plan with range
  def caption
    "#{plan.name} - #{formatted_range}"
  end

  def formatted_range
    case range
    when :week
      I18n.localize monday, format: :week_with_first_day
    else
      '???'
    end
  end

  def formatted_days
    days.map { |day| I18n.localize(day, format: :week_day) }
  end

  def filter
    model
  end

  def cell_content(day, employee)
    schedulings = schedulings_for(day, employee)
    unless schedulings.empty?
      h.render "schedulings/list_in_#{range || 'unknown'}",
        schedulings: schedulings
    end
  end

  def schedulings_for(day, employee)
    filter.indexed(day, employee).sort_by(&:start_hour)
  end

  def cell_metadata(day, employee)
    { employee_id: employee.id, date: day.iso8601 }
  end

  def table_metadata
    {
      organization_id: h.current_organization.id,
      plan_id:         plan.id,
      new_url:         h.new_organization_plan_scheduling_path(h.current_organization, plan)
    }
  end

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :cell
      if resource.is_a?(Scheduling)
        %Q~#calendar tbody td[data-date=#{resource.date.iso8601}][data-employee_id=#{resource.employee_id}]~
      else
        day, employee_id = resource, extra
        %Q~#calendar tbody td[data-date=#{day.iso8601}][data-employee_id=#{employee_id}]~
      end
    when :wwt_diff
      %Q~#calendar tbody tr[data-employee_id=#{resource.id}] th .wwt_diff~
    when :legend
      '#legend'
    else
      super
    end
  end

  def wwt_diff_for(employee)
    h.show_with_abbr(wwt_diff_label_text_for(employee),
                     wwt_diff_label_text_for(employee, opts={short: true}),
                     "badge #{wwt_diff_label_class_for(employee)}")
  end

  def wwt_diff_label_text_for(employee, opts={})
    if employee.weekly_working_time.present?
      opts[:short].present? ? txt = '/' : txt = 'von'
      "#{hours_for(employee)} #{txt} #{employee.weekly_working_time.to_i}"
    else
      "#{hours_for(employee)}"
    end
  end

  def wwt_diff_label_class_for(employee)
    return '' unless employee.weekly_working_time.present?
    difference = employee.weekly_working_time - hours_for(employee)
    if difference > 0
      'badge-warning'
    elsif difference < 0
      'badge-important'
    else
      'badge-success'
    end
  end

  def teams
    records.map(&:team).compact.uniq
  end

  def hours_for(employee)
    records.select {|s| s.employee == employee }.sum(&:length_in_hours).to_i
  end

  def employees
    organization.employees.order_by_names
  end

  delegate :plan,         to: :filter
  delegate :organization, to: :plan

  def respond_to_missing?(name)
    name =~ /^(.*)_for_scheduling$/ || super
  end

  # you can call a method anding in _for_scheduling
  def method_missing(name, *args, &block)
    if name =~ /^(.*)_for_scheduling$/
      scheduling = args.first
      send($1, scheduling.date, scheduling.employee)
    else
      super
    end
  end

  def link_to_previous_week(clss=nil, opts={})
    week = monday.prev_week
    h.link_to :previous_week, h.organization_plan_year_week_path(h.current_organization, plan, week.year, week.cweek), class: clss
  end

  def link_to_todays_week(clss=nil, opts={})
    week = Date.today
    h.link_to :this_week, h.organization_plan_year_week_path(h.current_organization, plan, week.year, week.cweek), class: clss
  end

  def link_to_next_week(clss=nil, opts={})
    week = monday.next_week
    h.link_to :next_week, h.organization_plan_year_week_path(h.current_organization, plan, week.year, week.cweek), class: clss
  end

  def respond(resource)
    if resource.errors.empty?
      update(resource)
      remove_modal
      update_legend
      update_quickie_completions
    else
      append_errors_for(resource)
    end
  end

  def update(resource)
    update_cell_for(resource)
    if resource.next_day
      update_cell_for(resource.next_day)
    end
    update_wwt_diff_for(resource.employee)
  end

  def update_cell_for(scheduling)
    select(:cell, scheduling).html cell_content_for_scheduling(scheduling) || ''
    select(:cell, scheduling).trigger 'update'
  end

  def update_wwt_diff_for(employee)
    select(:wwt_diff, employee).html wwt_diff_for(employee)
  end


  # FIXME WTF should use cdata_section to wrao team_styles, but it break the styles
  def legend
    h.content_tag(:style) { team_styles } +
      h.render('teams/legend', teams: teams)
  end

  def update_legend
    select(:legend).html legend
  end

  def update_quickie_completions
    page << "window.gon.quickie_completions=" + plan.schedulings.quickies.to_json
  end

  # TODO move into own view to fetch as an organization-specific asset
  def team_styles
    teams.map do |team|
      %Q~.#{dom_id(team)} { border-color: #{team.color};}~
    end.join(' ')
  end
end
