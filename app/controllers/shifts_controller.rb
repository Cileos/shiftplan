class ShiftsController < InheritedResources::Base
  load_and_authorize_resource

  nested_belongs_to :plan_template
  actions :all, :except => [:show]

  before_filter :merge_time_components_from_next_day, only: :edit

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

    # We always edit the first day of an overnight shift. So we need to initialize it, so
    # that the end time of the next day is set.
    def merge_time_components_from_next_day
      @shift.merge_time_components_from_next_day! if @shift.is_overnight?
    end
end
