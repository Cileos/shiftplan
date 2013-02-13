# The ShiftFilter helps to scope the selected Shifts to the
# selected range. It represents a week view of the plan template for
# display in a weekly calendar. It behaves like an ActiveRecord model
# and can therefor be used in forms to build searches.
class ShiftFilter < RecordFilter
  attribute :plan_template

  private
    def conditions
      { :plan_template_id => plan_template.id }
    end

    def sort_fields
      [:start_hour]
    end
end
