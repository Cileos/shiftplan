# This decorator has multiple `modes` to act in. These correspond to the
# different actions and views of the SchedulingsController.
class SchedulingFilterDecorator < ApplicationDecorator
  decorates :scheduling_filter

  # The title of the plan with range
  def caption
    "#{plan.name} - #{formatted_range}"
  end

  def plan_period
    plan_period = []
    if plan.starts_at.present?
      plan_period << I18n.t('schedulings.plan_period.starts_at', date: (I18n.localize plan.starts_at.to_date, format: :default))
    end
    if plan.ends_at.present?
      plan_period << I18n.t('schedulings.plan_period.ends_at', date: (I18n.localize plan.ends_at.to_date, format: :default))
    end
    plan_period.join(' ')
  end

  Modes = [:employees_in_week, :teams_in_week, :hours_in_week, :teams_in_day]

  def mode
    @mode ||= self.class.name.scan(/SchedulingFilter(.*)Decorator/).first.first.underscore
  end

  def mode?(query)
    mode.include?(query)
  end

  def self.decorate(input, opts={})
    mode = opts.delete(:mode) || opts.delete('mode')
    if page = opts[:page]
      mode ||= page.view.current_plan_mode
    end
    unless mode
      raise ArgumentError, 'must give :mode in options'
    end
    unless mode.in?( Modes.map(&:to_s) )
      raise ArgumentError, "mode is not supported: #{mode}"
    end
    "SchedulingFilter#{mode.classify}Decorator".constantize.new(input, opts)
  end


  def filter
    model
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

  def render_cell_for_day(day)
    cell_html_options = { data: cell_metadata(day) }
    if outside_plan_period?(day)
      cell_html_options.merge!(class: 'outside_plan_period')
    end

    h.content_tag :td, cell_content(day), cell_html_options
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
        %Q~#calendar tbody td[data-date=#{day.iso8601}][data-employee_id=#{employee_id}]~
      end
    when :scheduling
      %Q~#calendar tbody .scheduling[data-edit_url="#{resource.decorate.edit_url}"]~
    when :wwt_diff
      %Q~#calendar tbody tr[data-employee_id=#{resource.id}] th .wwt_diff~
    when :legend
      '#legend'
    when :team_colors
      '#team_colors'
    else
      super
    end
  end

  # selector for the cell of the given scheduling
  def cell_selector(scheduling)
     %Q~#calendar tbody td[data-date=#{scheduling.date.iso8601}][data-employee_id=#{scheduling.employee_id}]~
  end

  def wwt_diff_for(employee)
    h.abbr_tag(wwt_diff_label_text_for(employee, short: true),
               wwt_diff_label_text_for(employee),
               class: "badge #{wwt_diff_label_class_for(employee)}")
  end

  def wwt_diff_label_text_for(employee, opts={})
    if employee.weekly_working_time.present?
      opts[:short].present? ? txt = '/' : txt = 'von'
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

  def teams
    records.map(&:team).compact.uniq.sort_by(&:name)
  end

  def hours_for(employee)
    records.select {|s| s.employee == employee }.sum(&:length_in_hours).to_i
  end

  def employees
    organization.employees.order_by_names
  end

  delegate :plan,         to: :filter
  delegate :organization, to: :plan

  def coordinates_for_scheduling(scheduling)
    [ scheduling.date, scheduling.employee ]
  end

  # URI-Path to another week
  def path_to_week(date)
    raise(ArgumentError, "please give a date or datetime, got #{date.inspect}") unless date.acts_like?(:date) or date.acts_like?(:time)
    h.send(:"account_organization_plan_#{mode}_path", h.current_account, h.current_organization, plan, year: date.year_for_cweek, week: date.cweek)
  end

  def path_to_day(day)
    raise(ArgumentError, "please give a date or datetime") unless week.acts_like?(:date)
    raise(ArgumentError, "can only link to day in day view") unless mode?('day')
    h.send(:"account_organization_plan_#{mode}_path", h.current_account, h.current_organization, plan, year: day.year, month: day.month, day: day.day)
  end

  # URI-Path to another mode
  def path_to_mode(mode)
    raise(ArgumentError, "unknown mode: #{mode}") unless mode.in?(Modes)
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

  # TODO hooks?
  def respond(resource, action=:update)
    if resource.errors.empty?
      if action == :update
        respond_for_update(resource)
      else
        respond_for_create(resource)
      end
      remove_modal
      update_legend
      update_team_colors
      update_quickie_completions
    else
      prepend_errors_for(resource)
    end
  end

  def respond_for_create(resource)
    update_cell_for(resource)
    if resource.next_day
      update_cell_for(resource.next_day)
    end
    focus_element_for(resource)
  end

  def respond_for_update(resource)
    update_cell_for(resource.with_previous_changes_undone)
    respond_for_create(resource)
  end

  def update_cell_for(scheduling)
    update_wwt_diff_for(scheduling.employee)
    select(:cell, scheduling).refresh_html cell_content(scheduling) || ''
  end

  def focus_element_for(scheduling)
    select(:scheduling, scheduling).trigger('focus')
  end

  def update_wwt_diff_for(employee)
    select(:wwt_diff, employee).refresh_html wwt_diff_for(employee)
  end


  def update_quickie_completions
    page << "window.gon.quickie_completions=" + plan.schedulings.quickies.to_json
  end

  def legend
    h.render('teams/legend', teams: teams)
  end

  def update_legend
    select(:legend).refresh_html legend
  end

  def team_colors
    h.render 'teams/colors', teams: teams
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

end
