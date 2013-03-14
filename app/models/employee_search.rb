class EmployeeSearch

  attr_reader :base, :first_name, :last_name, :email, :organization, :except_employee

  def self.duplicates_for_employee(employee)
      new(
        first_name: employee.first_name,
        last_name: employee.last_name,
        base: employee.account.employees,
        except_employee: employee
      )
  end

  def initialize( attrs = {} )
    raise ArgumentError, 'no attribute :base given' unless attrs.has_key? :base

    @base          = attrs.delete(:base)
    @first_name    = attrs.delete(:first_name)
    @last_name     = attrs.delete(:last_name)
    @email         = attrs.delete(:email)
    @organization  = attrs.delete(:organization)
    @except_employee = attrs.delete(:except_employee)
  end

  def results
    scope = base
    scope = scope.where(first_name: first_name) if first_name.present?
    scope = scope.where(last_name: last_name) if last_name.present?
    if except_employee.present? && except_employee.persisted?
      scope = scope.where('id != ?', except_employee.id)
    end
    scope
  end

  def fuzzy_results
    scope = base
    scope = scope.where("first_name ILIKE ?", "#{first_name}%") if first_name.present?
    scope = scope.where("last_name ILIKE ?", "#{last_name}%") if last_name.present?
    scope = scope.joins(:user).where("users.email ILIKE ?", "#{email}%") if email.present?
    if organization.present?
      scope = scope.joins(:organizations).where(organizations: { id: organization })
    end
    if except_employee.present? && except_employee.persisted?
      scope = scope.where('id != ?', except_employee.id)
    end
    scope
  end

  # Enough parameters given to be actually different from .all
  def search?
    [first_name, last_name, email].any?(&:present?)
  end
end
