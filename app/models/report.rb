# encoding: utf-8
class Report < RecordFilter

  attribute :account
  attribute :organization
  attribute :organization_ids
  attribute :employee_ids
  attribute :team_ids
  attribute :limit
  attribute :from, type: Date
  attribute :to, type: Date

  def records
    @records ||= fetch_records
  end

  def total_duration
    @total_duration ||= all_records_without_next_days.sum { |s| s.decimal_duration }
  end

  def total_number_of_records
    @total_number_of_records ||= all_records_without_next_days.size
  end

  # The organization_id will be present when the user visits the report page of
  # an organization. At this moment, she is in the sope of an organization.
  def organization_id
    @organization_id ||= organization.try(:id)
  end

  def account_id
    @account_id ||= account.id
  end

  # The organization_ids will be present when the user is on the report page of
  # an account and filters by organizations.
  ['organization_ids', 'employee_ids', 'team_ids'].each do |method_name|
    define_method(method_name) do
      super() ? super().reject(&:blank?) : []
    end
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

  def all_records
    scoped = account.schedulings
    scoped = scoped.in_organizations(organization_list) if filter_by_organization?
    scoped = scoped.between(from, to)
    scoped = scoped.where(employee_id: employee_ids) unless employee_ids.empty?
    scoped = scoped.where(team_id: team_ids) unless team_ids.empty?
    scoped = scoped.order("starts_at DESC")
    scoped
  end

  def all_records_without_next_days
    @all_records_without_next_days ||= all_records.reject(&:previous_day)
  end

  def fetch_records
    rslt = all_records_without_next_days
    rslt = rslt.take(limit.to_i) if limit
    rslt
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
