class ShiftFilterDecorator < SchedulableFilterDecorator
  decorates :shift_filter

  def filter
    model
  end

  delegate :plan_template, to: :filter
  delegate :organization, to: :plan_template

  private

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :cell
      cell_selector(resource)
    when :next_cell
      next_cell_selector(resource)
    else
      super
    end
  end

  def cell_selector(shift)
     %Q~#calendar tbody td[data-day=#{shift.day}][data-team-id=#{shift.team_id}]~
  end

  def next_cell_selector(shift)
     %Q~#calendar tbody td[data-day=#{shift.day + 1}][data-team-id=#{shift.team_id}]~
  end

  def cell_content(*a)
    shifts = find_shifts(*a)
    content = ''
    unless shifts.empty?
      prepared = shifts.map(&:decorate).each do |shift|
        if a.first.is_a?(Shift) # single update, its day is ours
          shift.focus_day = a.first.day
        else
          shift.focus_day = a.first
        end
      end
      content = h.render "shifts/lists/teams_in_week", shifts: prepared, filter: self
    end
    h.content_tag :div, content, class: 'cellwrap'
  end

  # can give
  # 1) a Shift to find its cell mates
  # 2) coordinates to find all the shifts in cell (needs shifts_for implemented)
  def find_shifts(*criteria)
    if criteria.first.is_a?(Shift)
      shifts_for( *coordinates_for( criteria.first) )
    else
      # TODO
      shifts_for( *criteria )
    end
  end

  def coordinates_for(shift)
    [ shift.day, shift.team ]
  end

  def next_coordinates_for(shift)
    [ shift.day + 1, shift.team ]
  end
end
