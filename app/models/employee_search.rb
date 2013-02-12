class EmployeeSearch

  attr_reader :base, :first_name, :last_name, :email, :organization

  def initialize( attrs = {} )
    raise ArgumentError, 'no attribute :base given' unless attrs.has_key? :base

    @base          = attrs.delete(:base)
    @first_name    = attrs.delete(:first_name)
    @last_name     = attrs.delete(:last_name)
    @email         = attrs.delete(:email)
    @organization  = attrs.delete(:organization)
  end

  def results
    scope = sorted_base
    scope = scope.where(first_name: first_name) if first_name.present?
    scope = scope.where(last_name: last_name) if last_name.present?
    scope
  end

  def fuzzy_results
    scope = sorted_base
    scope = scope.where("first_name ILIKE ?", "#{first_name}%") if first_name.present?
    scope = scope.where("last_name ILIKE ?", "#{last_name}%") if last_name.present?
    scope = scope.joins(:user).where("users.email ILIKE ?", "#{email}%") if email.present?
    if organization.present?
      scope = scope.joins(:organizations).where(organizations: { id: organization })
    end
    scope
  end

  private

  def sorted_base
    base.order_by_names.order(:created_at)
  end
end
