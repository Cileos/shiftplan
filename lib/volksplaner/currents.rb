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

  # TODO load dynamically
  def set_current_account
    if params[:account_id]
      @current_account ||= Account.find(params[:account_id])
    end
  end

  def current_account
    @current_account
  end

  def current_account?
    current_account.present?
  end

  ######################################################################
  # Organization
  ######################################################################

  def organization_param
    params[:organization_id]
  end

  def current_organization
    if organization_param
      @current_organization ||= Organization.find(organization_param)
    end
  end

  def current_organization?
    current_organization.present?
  end


  ######################################################################
  # Employee
  ######################################################################

  # TODO load dynamically
  def set_current_employee
    if current_account?
      current_user.current_employee = current_user.employees.find_by_account_id!(current_account.id)
    else
      if first_owner = current_user.employees.owners.first
        current_user.current_employee = first_owner
        @current_account = first_owner.account
      end
    end
  end

  def current_employee
    current_user.try :current_employee
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
