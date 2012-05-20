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
      %Q~#calendar tbody td.wwt_diff[data-employee_id=#{resource.id}]~
    when :legend
      '#legend'
    else
      super
    end
  end

  # TODO deprecated atm
  def weekly_working_time_difference_header
    if week?
      h.content_tag :th do
        (h.content_tag(:span, (h.translate_action(:hours) + '/').html_safe +
                               h.content_tag(:abbr, h.translate_action(:wwt_short), {title: h.translate_action(:wwt_long)}).html_safe,
                              class: 'weekly_working_time') +
        h.content_tag(:abbr, title: h.translate_action(:hours) + '/' +h.translate_action(:wwt_long), class: 'weekly_working_time') do
          'h/' + h.translate_action(:wwt_short)
        end).html_safe
      end
    end
  end

  # TODO deprecated atm
  def weekly_working_time_difference_tag_for(employee)
    if week?
      h.content_tag :td, :class => 'wwt_diff', 'data-employee_id' => employee.id do
        wwt_diff_for_as_abbr(employee)
      end
    end
  end

  def wwt_diff_for(employee)
    h.content_tag :span, wwt_diff_label_text_for(employee), class: "badge #{wwt_diff_label_class_for(employee)}"
  end

  def wwt_diff_for_as_abbr(employee)
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
    organization.employees.order_by_name
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

  def link_to_previous_week
    week = monday.prev_week
    h.link_to :previous_week, h.organization_plan_year_week_path(h.current_organization, plan, week.year, week.cweek)
  end

  def link_to_next_week
    week = monday.next_week
    h.link_to :next_week, h.organization_plan_year_week_path(h.current_organization, plan, week.year, week.cweek)
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
