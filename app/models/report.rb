# encoding: utf-8
class Report < RecordFilter

  attribute :account
  attribute :organization
  attribute :organization_ids
  attribute :employee_ids
  attribute :from, type: Date
  attribute :to, type: Date

  def records
    @records ||= fetch_records
  end

  def organization_id
    @organization_id ||= organization.try(:id)
  end

  def account_id
    @account_id ||= account.id
  end

  def from
    (super || today.beginning_of_month).beginning_of_day
  end

  def to
    (super || today.end_of_month).end_of_day
  end

    private

  def fetch_records
    # Filters for the time range will be added later. As we do not have
    # pagination, yet, only show the schedulings of the current month for now.
    scoped = account.schedulings
    if filter_by_organization?
      scoped = scoped.in_organizations(organization_list)
    end
    scoped = scoped.between(from, to)
    scoped = scoped.where(employee_id: employee_ids_without_blank) unless employee_ids_without_blank.empty?
    scoped = scoped.order("starts_at DESC")

    scoped.reject(&:previous_day)
  end

  def employee_ids_without_blank
    employee_ids ? employee_ids.reject(&:blank?) : []
  end

  def organization_ids_without_blank
    organization_ids ? organization_ids.reject(&:blank?) : []
  end

  def organization_list
    organization_id ? [organization_id] : organization_ids_without_blank
  end

  def filter_by_organization?
    organization_ids_without_blank.present? || organization_id
  end

  def today
    Date.today
  end

end
