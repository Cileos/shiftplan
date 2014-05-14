class UnavailabilitiesController < InheritedResources::Base
  load_and_authorize_resource except: [:create]
  before_filter :ensure_year_and_month, only: :index

  respond_to :json, :html

  def create
    creator.call permitted_params.merge(user: current_user)
    respond_to do |format|
      format.json { render json: creator.created_records }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.json { render json: e.to_s, status: 401 }
    end
  end

protected
  def permitted_params
    good = [
      :employee_id,
      :starts_at,
      :ends_at,
      :reason,
      :description,
    ]
    if action_name == 'create'
      params.require(:unavailability).permit(*good, account_ids: [])
    else # implicitly ignore account_ids (ember data always sends all attrs)
      params.require(:unavailability).permit(*good)
    end
  end

  def ensure_year_and_month
    unless request.format.html?
      unless period_params?
        now = Time.current
        redirect_to unavailabilities_path year: now.year, month: now.month
      end
    end
  end

  def begin_of_association_chain
    if action_name == 'destroy' # cancan takes care of security
      nil
    else
      if employee?
        employee
      else
        current_user
      end
    end
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

  def employee?
    employee_id.present?
  end

  def employee
    @employee ||= Employee.find(employee_id)
  rescue
    nil
  end

  def employee_id
    if params[:unavailability]
      params[:unavailability][:employee_id]
    else
      params[:employee_id]
    end
  end

  def creator
    @creator ||= UnavailabilityCreator.new(self)
  end

end

