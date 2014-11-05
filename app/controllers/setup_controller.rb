class SetupController < InheritedResources::Base
  defaults resource_class: Setup, instance_name: 'setup'
  load_and_authorize_resource
  before_action :ensure_setup_present
  respond_to :html, only: [:show, :create]
  respond_to :json

  def create
    update! { setup_path }
  end

  def update
    if wants_execute?
      update! do |format|
        resource.execute!
        format.json do
          render json: { setup: { id: 'singleton', redirect_to: url_for(nested_resources_for(resource.plan)) } }
        end
      end
    else
      update!
    end
  end

  protected

  def resource
    @setup ||= current_user.setup
  end

  def build_resource
    @setup ||= current_user.build_setup(resource_params.first)
  end

  # the Setup is created during the Signup. If there is none present, either 
  # * the User signed up too early
  # * the User already completed a setup
  # so she already has all neccessary records set up
  def ensure_setup_present
    unless resource
      redirect_to dashboard_path
    end
  end

  def permitted_params
    params.permit(setup: [
      :employee_first_name,
      :employee_last_name,
      :account_name,
      :organization_name,
      :team_names,
      :time_zone_name,
    ])
  end

  # Ember sets "execute => true" when the "finish" button is pressed.
  def wants_execute?
    params[:setup] && params[:setup][:execute]
  end
end
