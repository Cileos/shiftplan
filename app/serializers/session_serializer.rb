class SessionSerializer < ApplicationSerializer
  attributes :id, :role, :can_manage_unavailabilities

  def role
    @options.fetch(:role) { 'unknown' }
  end

  def can_manage_unavailabilities
    object.memberships.any?(&:planner?) || !object.owned_accounts.empty?
  end

  # there is only one session: the current one
  def id
    'current'
  end
end
