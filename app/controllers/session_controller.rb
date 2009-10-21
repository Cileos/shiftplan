class SessionController < ApplicationController
  skip_before_filter :authenticate, :except => :destroy

  protect_from_forgery :except => :create
  layout 'session'

  def new
  end

  def create
    @user = User.authenticate(params[:session][:email], params[:session][:password])

    if @user && @user.email_confirmed?
      flash[:notice] = t(:successfully_logged_in)
      sign_in(@user)
      redirect_back_or(root_url)
    else
      flash[:error] = t(:could_not_log_in)
      render :action => 'new', :status => :unauthorized
    end
  end

  def destroy
    sign_out
    redirect_to(root_url)
  end
end
