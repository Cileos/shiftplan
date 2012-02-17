class SchedulingsController < InheritedResources::Base
  nested_belongs_to :plan
  actions :all, :except => [:show]

  respond_to :html, :js

  helper_method :range

  private
    def collection
      return @schedulings if @schedulings
      @schedulings = end_of_association_chain.filter( filter_params )
    end

    def filter_params
      if params[:week]
        params.slice(:week, :year).reverse_merge(:year => Date.today.year)
      else
        {}
      end.merge(:plan => parent)
    end
end
