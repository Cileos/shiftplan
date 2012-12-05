class ShiftsController < InheritedResources::Base
  load_and_authorize_resource

  nested_belongs_to :plan_template
  actions :all, :except => [:show]

  private

  def filter
    @filter ||= ShiftTeamsInWeekDecorator.new(@plan_template)
  end
  helper_method :filter
end
