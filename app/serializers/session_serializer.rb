class SessionSerializer < ApplicationSerializer
  attributes :id, :role, :can_manage_employees

  def role
    Array(object.roles).first
  end

  def can_manage_employees
    false
  end

  # there is only one session: the current one
  def id
    'current'
  end
end
