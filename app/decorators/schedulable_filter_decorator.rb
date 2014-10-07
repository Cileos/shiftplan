# This decorator has multiple `modes` to act in. These correspond to the
# different actions and views of the SchedulingsController.
class SchedulableFilterDecorator < ApplicationDecorator
  include ModeAwareness
  delegate_all
private

  def update_cell_for(schedulable)
    select(:cell, schedulable).refresh_html cell_content(schedulable) || ''
    if schedulable.is_overnight?
      update_next_cell_for(schedulable)
    end
  end

  def update_next_cell_for(schedulable)
    select(:next_cell, schedulable).refresh_html next_cell_content(schedulable) || ''
  end

  def next_cell_content(schedulable)
    cell_content *next_coordinates_for(schedulable)
  end
end

