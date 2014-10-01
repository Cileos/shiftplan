# This decorator has multiple `modes` to act in. These correspond to the
# different actions and views of the SchedulingsController.
class SchedulableFilterDecorator < ApplicationDecorator
  include ModeAwareness
  delegate_all
private

  def update_cell_for(schedulable)
    select(:cell, schedulable).refresh_html cell_content(schedulable) || ''
  end
end

