module Ember
  class SchedulingsController < BaseController
    respond_to :json

    def collection
      @schedulings ||= filter.records
    end

    def filter
      @filter ||= SchedulingFilter.new( filter_params )
    end

    def filter_params
      if false # TODO by plan if present
        timey_filter_params.reverse_merge(plan: plan)
      else
        timey_filter_params.reverse_merge(base: current_user.schedulings.where('1=1'))
      end
    end

    def timey_filter_params
      params
        .slice(:week, :year, :cwyear, :ids, :day, :month)
        .reverse_merge(:year => Date.today.year)
    end
  end
end
