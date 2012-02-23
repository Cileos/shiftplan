class SchedulingsController < InheritedResources::Base
  load_and_authorize_resource

  nested_belongs_to :plan
  actions :all, :except => [:show]

  respond_to :html, :js

  before_filter :set_completions

  private
    def collection
      @schedulings ||= filter.records
    end

    def filter
      @filter ||= Scheduling.filter( filter_params )
    end
    helper_method :filter

    def smart_resource_url
      plan_year_week_path(parent, resource.year, resource.week)
    end

    def filter_params
      params
        .slice(:week, :year)
        .reverse_merge(:year => Date.today.year)
        .merge(:plan => parent)
    end

    # pushes quickie completion data to JS
    # OPTIMIZE put this into a decorator to make it updatable
    def set_completions
      gon.quickie_completions = parent.schedulings.quickies
    end
end
