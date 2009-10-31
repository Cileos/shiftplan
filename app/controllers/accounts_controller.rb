# class AccountsController < ApplicationController
#   skip_before_filter :authenticate, :except => [:edit, :update]
#   layout 'session'
# 
#   def new
#     @account = Account.new
#   end
# 
#   def create
#     @account = Account.new(params[:account])
# 
#     if @account.save
#       flash[:notice] = t(:account_successfully_created)
#       redirect_to dashboard_url # temporary
#     else
#       flash[:error] = t(:account_could_not_be_created)
#       render :action => 'new'
#     end
#   end
# end
