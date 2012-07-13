class SchedulingsController < InheritedResources::Base
  load_and_authorize_resource

  nested_belongs_to :plan
  actions :all, :except => [:show]
  # same as SchedulingFilter::Modes - naming explicitly here because of
  # decoupling and we don't want eagler preloading here
  custom_actions collection: [:employees_in_week, :hours_in_week] 
  # FIXME obviously the custom actions are not neccessary if a view with the name exists
  layout 'calendar'

  respond_to :html, :js

  private
    def collection
      @schedulings ||= filter.records
    end

    def pure_filter
      @pure_filter ||= Scheduling.filter( filter_params )
    end

    def filter
      @filter ||= SchedulingFilterDecorator.decorate(pure_filter, mode: current_plan_mode || params[:action])
    end
    helper_method :filter

    def smart_resource_url
      organization_plan_year_week_path(current_organization, parent, resource.year, resource.week)
    end

    def filter_params
      params
        .slice(:week, :year, :ids, :day, :month)
        .reverse_merge(:year => Date.today.year)
        .merge(:plan => parent)
    end
end
