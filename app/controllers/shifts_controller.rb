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

    def collection
      @shifts ||= filter.records
    end

    def pure_filter
      @pure_filter ||= Shift.filter( filter_params )
    end

    def filter
      @filter ||= ShiftFilterDecorator.decorate(pure_filter, mode: 'teams_in_week')
    end
    helper_method :filter

    def filter_params
      { plan_template: plan_template }
    end

    def plan_template
      parent
    end
end
