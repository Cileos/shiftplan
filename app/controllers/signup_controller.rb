class SignupController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_authorization_check

  def show
    authorize! :show, resource
  end

  def create
    authorize! :create, resource
    if resource.valid?
      resource.save!
      redirect_to new_user_session_path
    else
      render action: 'show'
    end
  end

  private

  def resource
    @signup ||= Signup.new resource_params
  end

  def resource_params
    params[:signup]
  end

end
