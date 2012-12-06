class ShiftsController < InheritedResources::Base
  load_and_authorize_resource

  nested_belongs_to :plan_template
  actions :all, :except => [:show]

  respond_to :html, :js

  def new
    new! do
      # increase later
      1.times { @shift.demands.build }
    end
  end

  private

  def filter
    @filter ||= ShiftTeamsInWeekDecorator.new(@plan_template)
  end
  helper_method :filter
end
