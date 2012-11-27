class EmployeeSearch

  attr_reader :base, :first_name, :last_name, :email, :organization

  def initialize( attrs = {} )
    raise ArgumentError, 'no attribute :base given' unless attrs[:base].present?

    @base          = attrs.delete(:base)
    @first_name    = attrs.delete(:first_name)
    @last_name     = attrs.delete(:last_name)
    @email         = attrs.delete(:email)
    @organization  = attrs.delete(:organization)
  end

  def results
    scope = base
    scope = scope.where(first_name: first_name) if first_name.present?
    scope = scope.where(last_name: last_name) if last_name.present?
    scope
  end

  def fuzzy_results
    scope = base
    scope = scope.where("first_name LIKE ?", "#{first_name}%") if first_name.present?
    scope = scope.where("last_name LIKE ?", "#{last_name}%") if last_name.present?
    scope = scope.joins(:user).where("users.email LIKE ?", "#{email}%") if email.present?
    if organization.present?
      scope = scope.joins(:organizations).where(organizations: { id: organization })
    end
    scope
  end
end
