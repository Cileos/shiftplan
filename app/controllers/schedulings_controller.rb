class SchedulingsController < InheritedResources::Base
  load_and_authorize_resource

  nested_belongs_to :plan
  actions :all, :except => [:show]
  # same as SchedulingFilter::Modes - naming explicitly here because of
  # decoupling and we don't want eagler preloading here
  custom_actions collection: [:employees_in_week, :hours_in_week]
  # FIXME obviously the custom actions are not neccessary if a view with the name exists
  layout 'calendar'

  before_filter :validate_plan_period, except: [:new, :create, :edit, :update, :destroy] # but all the collections

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

    # InheritedResources
    def smart_resource_url
      filter.path_to_date(resource.date)
    end

    def filter_params
      params
        .slice(:week, :year, :cwyear, :ids, :day, :month)
        .reverse_merge(:year => Date.today.year)
        .merge(:plan => plan)
    end

    def validate_plan_period
      if filter.before_start_of_plan?
        redirect_to filter.path_to_date( plan.starts_at )
        return
      end
      if filter.after_end_of_plan?
        redirect_to filter.path_to_date( plan.ends_at )
        return
      end
    end

    def plan
      parent
    end
end
