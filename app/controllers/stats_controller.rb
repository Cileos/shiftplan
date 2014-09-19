class StatsController < ApplicationController
  skip_authorization_check
  before_filter :authorize_only_cileos_super_users

  def index
  end
end
