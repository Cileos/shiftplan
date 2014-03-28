class UnavailabilitiesController < BaseController
  before_filter :ensure_year_and_month, only: :index

  respond_to :json, :html

protected
  def ensure_year_and_month
    unless request.format.html?
      unless period_params?
        now = Time.current
        redirect_to unavailabilities_path year: now.year, month: now.month
      end
    end
  end

  def begin_of_association_chain
    current_user
  end

  def collection
    return [] unless period_params?
    @unavailabilities ||= end_of_association_chain.between(*requested_period)
  end

  def requested_period
    date = Date.new(params[:year].to_i, params[:month].to_i, 1).to_time_in_current_zone

    [date.beginning_of_month - 2.days, date.end_of_month + 2.days]
  end

  def period_params?
    params[:year] && params[:month]
  end

end

