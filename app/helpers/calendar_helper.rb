module CalendarHelper
  def clickable_class
    can?(:manage, Scheduling) ? 'clickable' : 'not-clickable'
  end
end
