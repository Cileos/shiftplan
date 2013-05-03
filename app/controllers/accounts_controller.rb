class AccountsController < BaseController
  actions :all

  after_filter  :setup_account,       only: :create
  before_filter :prepare_new_account, only: :new

  protected

  def setup_account
    resource.setup
  end

  def prepare_new_account
    resource.on_new_account = true
    if current_user.employees.present?
      resource.first_name = current_user.employees.first.first_name
      resource.last_name = current_user.employees.first.last_name
    end
  end
end
