# encoding: utf-8
class Report < RecordFilter

  attribute :account
  attribute :organization
  attribute :employee_id
  attribute :from, type: Date
  attribute :to, type: Date

  def records
    fetch_records
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
    scoped = base.schedulings
    scoped = scoped.between(from, to)
    scoped = scoped.where(employee_id: employee_id) if employee_id.present?
    scoped = scoped.order("starts_at DESC")

    scoped.reject(&:previous_day)
  end

  def base
    organization || account
  end

  def today
    Date.today
  end

end
