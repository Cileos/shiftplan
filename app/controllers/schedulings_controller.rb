class SchedulingsController < BaseController
  nested_belongs_to :account, :organization, :plan
  actions :all, :except => [:show]
  # same as SchedulingFilter.supported_modes - naming explicitly here because of
  # decoupling and we don't want eagler preloading here
  custom_actions collection: [:employees_in_week, :hours_in_week]
  # FIXME obviously the custom actions are not neccessary if a view with the name exists
  layout 'calendar'

  with_options except: [:new, :create, :edit, :update, :destroy] do |only_collections|
    only_collections.before_filter :validate_plan_period
    only_collections.before_filter :find_conflicts
  end
  before_filter :merge_time_components_from_next_day, only: :edit

  respond_to :html, :js
  force_no_cache

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
      VP::PlanRedirector.new(self, plan).validate_and_redirect(filter)
    end

    def find_conflicts
      ConflictFinder.new( filter.records ).call
    end

    def plan
      parent
    end

    # We always edit the first day of an overnightable. This makes it necessary to
    # initialize the first day with the end_hour and end_minute of the next day.
    def merge_time_components_from_next_day
      resource.merge_time_components_from_next_day! if resource.is_overnight?
    end
end
