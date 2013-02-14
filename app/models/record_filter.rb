# The RecordFilter helps to scope the selected records to the
# selected range. It represents a week view of the plan or plan template for
# display in a weekly calendar. It behaves like an ActiveRecord model
# and can therefore be used in forms to build searches.
class RecordFilter
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::AttributeDefaults
  include Draper::Decoratable

  attribute :plan_template
  attribute :base

  delegate :all, to: :records
  delegate :count, to: :base

  # These _are_ the records you are looking for
  def records
    @records ||= fetch_records
  end

  def base
    self.class.name.gsub('Filter', '').constantize
  end

  private

    def fetch_records
      results = base
      results = results.where(conditions)
      results = results.includes(*to_include) unless to_include.empty?
      sort_fields.each do |field|
        results = results.sort_by(&field)
      end
      results
    end

    # if you need conditions for base, please override in subclass
    def conditions
      {}
    end

    # if you need to include associations of the model in the resuls set, please
    # override in subclass
    def to_include
      []
    end

    # if you need to sort results, please override in subclass
    def sort_fields
      []
    end
end
