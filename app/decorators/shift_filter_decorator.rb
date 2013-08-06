# This decorator has multiple `modes` to act in. These correspond to the
# different actions and views of the ShiftsController.
# OPTIMIZE unify with SchedulingFilterDecorator (by superclass)
class ShiftFilterDecorator < ApplicationDecorator
  decorates :shift_filter
  delegate_all

  include ModeAwareness

  def filter
    model
  end

  delegate :plan_template, to: :filter
  delegate :organization, to: :plan_template

  private

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
    content = ''
    unless shifts.empty?
      content = h.render "shifts/lists/teams_in_week", shifts: shifts.map(&:decorate), filter: self
    end
    h.content_tag :div, content, class: 'cellwrap'
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
