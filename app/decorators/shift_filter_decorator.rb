# This decorator has multiple `modes` to act in. These correspond to the
# different actions and views of the ShiftsController.
class ShiftFilterDecorator < ApplicationDecorator
  decorates :shift_filter

  Modes = [:teams_in_week]

  def mode
    @mode ||= self.class.name.scan(/ShiftFilter(.*)Decorator/).first.first.underscore
  end

  def mode?(query)
    mode.include?(query)
  end

  def self.decorate(input, opts={})
    mode = opts.delete(:mode) || opts.delete('mode')
    # TODO support more modes
    mode = 'teams_in_week'
    unless mode
      raise ArgumentError, 'must give :mode in options'
    end
    unless mode.in?( Modes.map(&:to_s) )
      raise ArgumentError, "mode is not supported: #{mode}"
    end
    "ShiftFilter#{mode.classify}Decorator".constantize.new(input, opts)
  end


  def filter
    model
  end

  delegate :plan_template, to: :filter
  delegate :organization, to: :plan_template

  def respond(resource, action=:update)
    if resource.errors.empty?
      case action
      when :update
        respond_for_update(resource)
      else
        respond_for_action(resource)
      end
      remove_modal
    else
      prepend_errors_for(resource)
    end
  end

  private

  def respond_for_update(resource)
    update_cell_for(resource.with_previous_changes_undone)
    if resource.first_day?
      update_cell_for(resource.overnight_mate.with_previous_changes_undone)
    end
    respond_for_action(resource)
  end

  def respond_for_action(resource)
    update_cell_for(resource)
    if resource.first_day?
      update_cell_for(resource.overnight_mate)
    end
  end

  def update_cell_for(shift)
    select(:cell, shift).refresh_html cell_content(shift) || ''
  end

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :cell
      cell_selector(resource)
    else
      super
    end
  end

  def cell_selector(shift)
     %Q~#calendar tbody td[data-day=#{shift.day}][data-team-id=#{shift.team_id}]~
  end

  def cell_content(*a)
    shifts = find_shifts(*a)
    unless shifts.empty?
      h.render "shifts/lists/teams_in_week", shifts: shifts.map(&:decorate), filter: self
    end
  end

  # can give
  # 1) a Shift to find its cell mates
  # 2) coordinates to find all the shifts in cell (needs shifts_for implemented)
  def find_shifts(*criteria)
    if criteria.first.is_a?(Shift)
      shifts_for( *coordinates_for_shift( criteria.first) )
    else
      # TODO
      shifts_for( *criteria )
    end
  end

  def coordinates_for_shift(shift)
    [ shift.day, shift.team ]
  end
end
