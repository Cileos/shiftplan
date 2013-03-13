module CalendarHelper
  def editable_class
    can?(:manage, Scheduling) ? 'editable' : 'readonly'
  end
end
