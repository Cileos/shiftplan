# encoding: utf-8
class Report < RecordFilter

  attribute :account
  attribute :organization
  attribute :organization_ids
  attribute :employee_ids
  attribute :limit
  attribute :from, type: Date
  attribute :to, type: Date

  def records
    @records ||= fetch_records
  end

  # The organization_id will be present when the user visits the report page of
  # an organization. At this moment, she is in the sope of an organization.
  def organization_id
    @organization_id ||= organization.try(:id)
  end

  def account_id
    @account_id ||= account.id
  end

  def employee_ids
    super ? super.reject(&:blank?) : []
  end

  # The organization_ids will be present when the user is on the report page of
  # an account and filters by organizations.
  def organization_ids
    super ? super.reject(&:blank?) : []
  end

  def from
    (super || today.beginning_of_month).beginning_of_day
  end

  def to
    (super || today.end_of_month).end_of_day
  end

  def limit
    super == 'all' ? nil : super || 50
  end

    private

  def fetch_records
    scoped = account.schedulings
    scoped = scoped.in_organizations(organization_list) if filter_by_organization?
    scoped = scoped.between(from, to)
    scoped = scoped.where(employee_id: employee_ids) unless employee_ids.empty?
    scoped = scoped.limit(limit)
    scoped = scoped.order("starts_at DESC")

    scoped.reject(&:previous_day)
  end

  def organization_list
    organization_id ? [organization_id] : organization_ids
  end

  def filter_by_organization?
    organization_ids.present? || organization_id
  end

  def today
    Date.today
  end
end
