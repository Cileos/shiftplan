class ShiftsController < BaseController
  nested_belongs_to :account, :organization, :plan_template
  actions :all, :except => [:show]

  before_filter :merge_time_components_from_next_day, only: :edit

  respond_to :html, :js

  def new
    new! do
      # increase later
      1.times { @shift.demands.build(quantity: 1) }
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

  # We always edit the first day of an overnightable. This makes it necessary to
  # initialize the first day with the end_hour and end_minute of the next day.
    def merge_time_components_from_next_day
      @shift.merge_time_components_from_next_day! if @shift.is_overnight?
    end

    def permitted_params
      params.permit shift: [
        :start_hour,
        :end_hour,
        :start_minute,
        :end_minute,
        :start_time,
        :end_time,
        :day,
        :team_id,
        :all_day,
        { demands_attributes: [
          :quantity,
          :qualification_id,
          :_destroy,
        ]}
      ]
    end
end
