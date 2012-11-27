class EmployeeSearch

  attr_reader :base, :first_name, :last_name, :email, :organization

  def initialize( attrs = {} )
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
  end
end
