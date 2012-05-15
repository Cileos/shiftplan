class SchedulingsController < InheritedResources::Base
  load_and_authorize_resource

  nested_belongs_to :plan
  actions :all, :except => [:show]

  respond_to :html, :js

  private
    def collection
      @schedulings ||= filter.records
    end

    def filter
      @filter ||= Scheduling.filter( filter_params )
    end
    helper_method :filter

    def smart_resource_url
      organization_plan_year_week_path(current_organization, parent, resource.year, resource.week)
    end

    def filter_params
      params
        .slice(:week, :year, :ids)
        .reverse_merge(:year => Date.today.year)
        .merge(:plan => parent)
    end
end
