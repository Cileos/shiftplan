class AccountsController < BaseController
  actions :all

  respond_to :json, :js, :html

  after_filter  :setup_account,       only: :create
  before_filter :prepare_new_account, only: :new

  def update
    update! { accounts_path }
  end

  protected

  def begin_of_association_chain
    current_user
  end

  def end_of_association_chain
    super.default_sorting
  end

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
