class CurrentUserController < ApplicationController
  respond_to :json, only: :show

  def show
    respond_to do |wants|
      wants.json { render json: current_user, serializer: UserWithAbilitiesSerializer, root: 'session' }
    end
  end
end
