# The ShiftFilter helps to scope the selected Shifts to the
# selected range. It represents a week view of the plan template for
# display in a weekly calendar. It behaves like an ActiveRecord model
# and can therefor be used in forms to build searches.
class ShiftFilter
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::AttributeDefaults
  include Draper::ModelSupport

  attribute :plan_template
  attribute :base, default: Shift

  # These _are_ the Shifts you are looking for
  def records
    @records ||= fetch_records
  end

  private
    def fetch_records
      base.where(conditions).sort_by(&:start_hour)
    end

    def conditions
      { :plan_template_id => plan_template.id }
    end
end
