class ShiftsController < InheritedResources::Base
  load_and_authorize_resource

  nested_belongs_to :plan_template
  actions :all, :except => [:show]

  respond_to :html, :js

  private

  def filter
    @filter ||= ShiftTeamsInWeekDecorator.new(@plan_template)
  end
  helper_method :filter
end
