class ConfirmationsController < Devise::ConfirmationsController

  # We show an expressive flash message when the confirmation_token does not
  # match any known (for example when user clicks the confirmation link in the
  # email twice). Without this, simple_form just says samething like "something
  # went wrong"
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      resource.errors.clear
      set_flash_message(:alert, :unknown_token_or_already_confirmed) if is_flashing_format?
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end

end
