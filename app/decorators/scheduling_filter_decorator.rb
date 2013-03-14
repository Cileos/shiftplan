# This decorator has multiple `modes` to act in. These correspond to the
# different actions and views of the SchedulingsController.
class SchedulingFilterDecorator < ApplicationDecorator
  include ModeAwareness

  decorates :scheduling_filter

  delegate_all

  def self.supported_modes
    [:employees_in_week, :teams_in_week, :hours_in_week, :teams_in_day]
  end

  # The title of the plan with range
  def caption
    "#{plan.name} - #{formatted_range}"
  end

  def plan_period
    plan_period = []
    plan_period << plan_period_start_date if plan.starts_at.present?
    plan_period << plan_period_end_date if plan.ends_at.present?
    plan_period.join(' ')
  end

  def plan_period_start_date
    if plan.starts_at.present?
      I18n.t('schedulings.plan_period.starts_at', date: (I18n.localize plan.starts_at.to_date, format: :default))
    end
  end

  def plan_period_end_date
    if plan.ends_at.present?
      I18n.t('schedulings.plan_period.ends_at', date: (I18n.localize plan.ends_at.to_date, format: :default))
    end
  end

  def filter
    source
  end

  def table_metadata
    {
      organization_id: h.current_organization.id,
      plan_id:         plan.id,
      new_url:         h.new_account_organization_plan_scheduling_path(h.current_account, h.current_organization, plan),
      mode:            mode
    }
  end

  def quickies_for_completion
    plan.schedulings.quickies
  end

  def cell_metadata(*a)
    { }
  end

  def cell_content(*a)
    schedulings = find_schedulings(*a)
    unless schedulings.empty?
      h.render "schedulings/lists/#{mode}", schedulings: schedulings.map(&:decorate), filter: self
    end
  end

  def render_cell_for_day(day, *a)
    options = a.extract_options!
    options[:data] = cell_metadata(day, *a)
    if outside_plan_period?(day)
      options[:class] = "outside_plan_period #{options[:class]}".strip
    end

    h.content_tag :td, cell_content(day, *a), options
  end

  # can give
  # 1) a Scheduling to find its cell mates
  # 2) coordinates to find all the scheudlings in cell (needs schedulings_for implemented)
  def find_schedulings(*criteria)
    if criteria.first.is_a?(Scheduling)
      schedulings_for( *coordinates_for_scheduling( criteria.first) )
    else
      schedulings_for( *criteria )
    end
  end

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :cell
      if resource.is_a?(Scheduling)
        cell_selector(resource)
      else
        day, employee_id = resource, extra
        %Q~#calendar tbody td[data-date=#{day.iso8601}][data-employee-id=#{employee_id}]~
      end
    when :scheduling
      %Q~#calendar tbody .scheduling[data-edit_url="#{resource.decorate.edit_url}"]~
    when :wwt_diff
      %Q~#calendar tbody tr[data-employee-id=#{resource.id}] th .wwt_diff~
    when :legend
      '#legend'
    when :team_colors
      '#team_colors'
    when :calendar
      '#calendar'
    else
      super
    end
  end

  # selector for the cell of the given scheduling
  def cell_selector(scheduling)
     %Q~#calendar tbody td[data-date=#{scheduling.date.iso8601}][data-employee-id=#{scheduling.employee_id}]~
  end

  def wwt_diff_for(employee)
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

  # teams already scheduled in current week
  def active_teams
    @active_teams ||= records.map(&:team).compact.uniq.sort_by(&:name)
  end

  # teams of organization not yet scheduled in current week
  def inactive_teams
    organization.teams - active_teams
  end

  def hours_for(employee)
    records.select {|s| s.employee == employee }.sum(&:length_in_hours).to_i
  end

  def employees
    organization.employees
  end

  delegate :plan,         to: :filter
  delegate :organization, to: :plan

  def coordinates_for_scheduling(scheduling)
    [ scheduling.date, scheduling.employee ]
  end

  # URI-Path to another week
  def path_to_week(date)
    raise(ArgumentError, "please give a date or datetime, got #{date.inspect}") unless date.acts_like?(:date) or date.acts_like?(:time)
    h.send(:"account_organization_plan_#{mode}_path", h.current_account, h.current_organization, plan, cwyear: date.cwyear, week: date.cweek)
  end

  def path_to_day(day)
    raise(ArgumentError, "please give a date or datetime") unless day.acts_like?(:date)
    raise(ArgumentError, "can only link to day in day view") unless mode?('day')
    h.send(:"account_organization_plan_#{mode}_path", h.current_account, h.current_organization, plan, year: day.year, month: day.month, day: day.day)
  end

  # URI-Path to another mode
  def path_to_mode(mode)
    raise(ArgumentError, "unknown mode: #{mode}") unless mode.in?(SchedulingFilterDecorator.supported_modes)
    if mode =~ /week/
      # Array notation breaks on week-Fixnums
      h.plan_week_mode_path(plan, mode, monday)
    else
      '#' # TODO
    end
  end

  # Path to view with given date, mus tbe implemented in subclass, for example to find the corresponding week
  def path_to_date(date)
    raise NotImplementedError, 'should return path to view including the given date'
  end

  def previous_path
    path_to_date(previous_step)
  end

  def next_path
    path_to_date(next_step)
  end

  def path_to_day(day=monday)
    h.account_organization_plan_teams_in_day_path(h.current_account, h.current_organization, plan, day.year, day.month, day.day)
  end

  def update_cell_for(scheduling)
    update_wwt_diff_for(scheduling.employee) if scheduling.employee.present?
    select(:cell, scheduling).refresh_html cell_content(scheduling) || ''
  end

  def focus_element_for(scheduling)
    select(:scheduling, scheduling).trigger('focus')
  end

  def update_wwt_diff_for(employee)
    select(:wwt_diff, employee).refresh_html wwt_diff_for(employee)
  end


  def update_quickie_completions
    page << "window.gon.quickie_completions=" + quickies_for_completion.to_json
  end

  def legend
    h.render('teams/legend', active_teams: active_teams,
             inactive_teams: inactive_teams)
  end

  def update_legend
    select(:legend).refresh_html legend
  end

  # we only need to update colors of active teams
  def team_colors
    h.render 'teams/colors', teams: active_teams
  end

  def update_team_colors
    select(:team_colors).refresh_html team_colors
  end

  def has_previous?
    if plan.starts_at.present?
      plan.starts_at.to_date <= previous_week.days.last.to_date
    else
      true
    end
  end

  def has_next?
    if plan.ends_at.present?
      plan.ends_at.to_date >= next_step.to_date
    else
      true
    end
  end

  def respond_specially(resource=nil)
    update_legend
    update_team_colors
    update_quickie_completions
    focus_element_for(resource) unless resource.destroyed?
  end

  # Refreshes the whole #calendar, very expensive in comparison to other RJS
  # responses. Use with care.
  # The container table#calendar should not be replaced itself, because all the
  # behaviours are attached to it.
  def refresh_calendar
    select(:calendar).refresh_html h.render("schedulings/#{mode}", filter: self)
  end
end
