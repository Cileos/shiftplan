class UsersController < ApplicationController
  def new
    @user = User.new(params[:user])
  end

  def create
    params[:user].merge!(:email_confirmed => true) # temporary
    @user = User.new(params[:user])

    if @user.save
      redirect_to new_session_url
    else
      render :action => 'new'
    end
  end
end
