# include this into your controller to manage and access current records.
# The #current_user is from devise, btw :)
#
# OPTIMIZE There are currently three ways implemented of accessing something
# current. Extra points for refactoring this with a little hint of
# metaprogramming :)
#
module Volksplaner::Currents

  def self.included(controller)
    controller.class_eval do
      helper_method :current_account
      helper_method :current_account?
      helper_method :current_organization
      helper_method :current_organization?
      helper_method :current_employee
      helper_method :current_plan_mode
    end
  end

  ######################################################################
  # Account
  ######################################################################

  def find_current_account
    if params[:account_id]
      Account.find(params[:account_id])
    else
      if user_signed_in? && current_user.accounts.count == 1
        current_user.accounts.first
      end
    end
  end

  def current_account
    @current_account ||= find_current_account
  end

  def current_account?
    current_account.present?
  end

  ######################################################################
  # Organization
  ######################################################################

  def find_current_organization
    if current_account?
      possibilities = current_user.organizations_for(current_account)
      if params[:organization_id]
        possibilities.find(params[:organization_id])
      elsif possibilities.count == 1
        possibilities.first
      end
    end
  end

  def current_organization
    @current_organization ||= find_current_organization
  end

  def current_organization?
    current_organization.present?
  end


  ######################################################################
  # Employee
  ######################################################################

  # TODO load dynamically
  def find_current_employee
    if current_account?
      current_user.current_employee = current_user.employee_for_account(current_account)
    end
  end

  def current_employee
    if user_signed_in?
      return @current_employee if defined?(@current_employee)
      current_user.current_employee = @current_employee = find_current_employee
    end
  end

  def current_employee?
    current_employee.present?
  end

  def prefetch_current_employee
    current_employee || true
  end

  ######################################################################
  # etc
  ######################################################################

  # HACK on every AJAX request, we deliver the mode of the plan in a header, so
  # the RJS responses can figure out the correct decorators
  # FIXME: remove with RJS
  def current_plan_mode
    if mode = request.headers['HTTP_X_SHIFTPLAN_MODE'] || params['_shiftplan_mode']
      mode.inquiry
    else
      nil
    end
  end
end
