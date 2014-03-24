class UnavailabilitiesController < BaseController
  before_filter :ensure_year_and_month, only: :index

  respond_to :json, :html

protected
  def ensure_year_and_month
    unless params[:year] && params[:month]
      now = Time.current
      redirect_to unavailabilities_path year: now.year, month: now.month
    end
  end

  def begin_of_association_chain
    current_user
  end
end

