# This decorator has multiple `modes` to act in. These correspond to the
# different actions and views of the SchedulingsController.
class SchedulingFilterDecorator < ApplicationDecorator
  decorates :scheduling_filter

  # The title of the plan with range
  def caption
    "#{plan.name} - #{formatted_range}"
  end

  Modes = [:employees_in_week, :hours_in_week]

  def mode
    self.class.name.scan(/SchedulingFilter(.*)Decorator/).first.first.underscore
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


  def formatted_days
    days.map do |day|
      [
        I18n.localize(day, format: :week_day),
        I18n.localize(day, format: :abbr_week_day)
      ]
    end
  end

  def filter
    model
  end

  def table_metadata
    {
      organization_id: h.current_organization.id,
      plan_id:         plan.id,
      new_url:         h.new_organization_plan_scheduling_path(h.current_organization, plan),
      mode:            mode
    }
  end

  def cell_metadata(*a)
    { }
  end

  def cell_content(*a)
    schedulings = schedulings_for(*a)
    unless schedulings.empty?
      h.render "schedulings/lists/#{mode}", schedulings: schedulings.map(&:decorate)
    end
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
    else
      super
    end
  end

  def wwt_diff_for(employee)
    h.abbr_tag(wwt_diff_label_text_for(employee),
               wwt_diff_label_text_for(employee, short: true),
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

  # you can call a method ending in _for_scheduling
  def method_missing(name, *args, &block)
    if name =~ /^(.*)_for_scheduling$/
      scheduling = args.first
      send($1, scheduling.date, scheduling.employee)
    else
      super
    end
  end

  # URI-Path to another week
  def path_to_week(week)
    raise(ArgumentError, "please give a date or datetime") unless week.acts_like?(:date)
    h.organization_plan_year_week_path(h.current_organization, plan, week.year, week.cweek)
  end

  # URI-Path to another mode
  def path_to_mode(mode)
    raise(ArgumentError, "unknown mode: #{mode}") unless mode.in?(Modes)
    if mode =~ /week/
      # Array notation breaks on week-Fixnums
      h.send("organization_plan_#{mode}_path", h.current_organization, plan, monday.year, monday.cweek)
    else
      '#' # TODO
    end

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


  def update_quickie_completions
    page << "window.gon.quickie_completions=" + plan.schedulings.quickies.to_json
  end
end
