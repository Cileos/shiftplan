class SchedulingsController < InheritedResources::Base
  nested_belongs_to :plan
  actions :all, :except => [:show]

  respond_to :html, :js

  private
    def collection
      return @schedulings if @schedulings
      @schedulings = Scheduling.filter( filter_params )
    end

    def smart_resource_url
      plan_year_week_path(parent, resource.year, resource.week)
    end

    def filter_params
      if params[:week]
        params.slice(:week, :year).reverse_merge(:year => Date.today.year)
      else
        {}
      end.merge(:plan => parent)
    end
end
