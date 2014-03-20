# encoding: utf-8
class Report < RecordFilter

  attribute :account
  attribute :organization
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
    super || Time.zone.now.to_date.beginning_of_month
  end

  def to
    super || Time.zone.now.to_date.end_of_month
  end

    private

  def fetch_records
    # Filters for the time range will be added later. As we do not have
    # pagination, yet, only show the schedulings of the current month for now.
    base.schedulings.
      between(from.to_time_in_current_zone.beginning_of_day, to.to_time_in_current_zone.end_of_day).
      order("starts_at DESC").
      reject(&:previous_day)
  end

  def base
    organization || account
  end
end
