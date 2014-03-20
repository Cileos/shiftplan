# encoding: utf-8
class Report < RecordFilter

  attribute :account
  attribute :organization

  def records
    fetch_records
  end

  def organization_id
    @organization_id ||= organization.try(:id)
  end

  def account_id
    @account_id ||= account.id
  end

    private

  def fetch_records
    # Filters for the time range will be added later. As we do not have
    # pagination, yet, only show the schedulings of the current month for now.
    base.schedulings.
      from_month(Time.zone.now).
      order("starts_at DESC").
      reject(&:previous_day)
  end

  def base
    organization || account
  end
end
