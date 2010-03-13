class UsersController < ApplicationController
  skip_before_filter :authenticate, :except => [:edit, :update]

  def new
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      @user.confirm! # temporary
      redirect_to new_session_url
    else
      render :action => 'new'
    end
  end
end
