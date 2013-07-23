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
      helper_method :current_employee?
      helper_method :current_membership
      helper_method :current_membership?
      helper_method :current_plan_mode
    end
  end

  def current_account
    @current_account ||= find_current_account
  end

  def current_account?
    current_account.present?
  end

  def current_organization
    @current_organization ||= find_current_organization
  end

  def current_organization?
    current_organization.present?
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

  ######################################################################
  # etc
  ######################################################################

  # HACK on every AJAX request, we deliver the mode of the plan in a header, so
  # the RJS responses can figure out the correct decorators
  # FIXME: remove with RJS
  def current_plan_mode
    if mode = request.headers['HTTP_X_CLOCKWORK_MODE'] || params['_clockwork_mode']
      mode.inquiry
    else
      nil
    end
  end

  private

  def find_current_account
    if user_signed_in?
      possibilities = current_user.accounts
      if params[:controller] == 'accounts' && params[:id]
        possibilities.find(params[:id])
      elsif params[:account_id]
        possibilities.find(params[:account_id])
      elsif possibilities.count == 1
        possibilities.first
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    return nil
  end

  def find_current_organization
    if current_account?
      if current_organization_by_params.present?
        current_organization_by_params
      elsif possible_organizations? && possible_organizations.count == 1
        possible_organizations.first
      end
    end
  end

  def find_current_organization_by_params
    if params[:organization_id]
      possible_organizations.find(params[:organization_id])
    elsif params[:controller] == 'organizations' && params[:id]
      possible_organizations.find(params[:id])
    end
  end

  def find_current_membership
    if current_organization_by_params.present?
      current_employee.memberships.find_by_organization_id(current_organization_by_params.id)
    end
  end

  def possible_organizations
    if current_account?
      @possible_organizations ||= current_user.organizations_for(current_account)
    end
  end

  def possible_organizations?
    possible_organizations.present?
  end

  def current_organization_by_params
    @current_organization_by_params ||= find_current_organization_by_params
  end

  def current_membership
    return @current_membership if defined?(@current_membership)
    current_user.current_membership = @current_membership = find_current_membership
  end

  # TODO load dynamically
  def find_current_employee
    if user_signed_in? && current_account?
      current_user.employee_for_account(current_account)
    end
  end

end
