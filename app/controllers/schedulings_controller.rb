class SchedulingsController < InheritedResources::Base
  nested_belongs_to :plan
  actions :all, :except => [:show]

  respond_to :html, :js

  def create
    create! do |success, failure|
      success.html { redirect_to plan_year_week_path(parent, resource.year, resource.week) }
      failure.html { render :text => 'TODO redisplay form' }
    end
  end

  private
    def collection
      return @schedulings if @schedulings
      @schedulings = Scheduling.filter( filter_params )
    end

    def filter_params
      if params[:week]
        params.slice(:week, :year).reverse_merge(:year => Date.today.year)
      else
        {}
      end.merge(:plan => parent)
    end
end
