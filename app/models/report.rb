# encoding: utf-8
class Report < RecordFilter

  CHUNK_SIZES = [ 50, 100, 250 ]

  attribute :account
  attribute :organization_ids
  attribute :employee_ids
  attribute :team_ids
  attribute :plan_ids
  attribute :limit
  attribute :from, type: Date
  attribute :to, type: Date

  def records
    @records ||= fetch_records
  end

  def total_duration
    @total_duration ||= all_records.
      reject { |s| s.all_day? }.
      sum(&:length_in_hours)
  end

  def total_number_of_records
    @total_number_of_records ||= all_records.size
  end

  def account_id
    @account_id ||= account.id
  end

  # The organization_ids will be present when the user is on the report page of
  # an account and filters by organizations.
  ['organization_ids', 'employee_ids', 'team_ids', 'plan_ids'].each do |method_name|
    define_method(method_name) do
      Array(super()).reject(&:blank?)
    end
  end

  def from
    (super || today.beginning_of_month).beginning_of_day
  end

  def to
    (super || today.end_of_month).end_of_day
  end

  def limit
    super == 'all' ? nil : super || chunk_sizes.first
  end

  def chunk_sizes
    CHUNK_SIZES
  end

    private

  def all_records
    scoped = account.schedulings
    scoped = scoped.in_organizations(organization_ids) unless organization_ids.empty?
    scoped = scoped.starts_between(from, to)
    scoped = scoped.where(employee_id: employee_ids) unless employee_ids.empty?
    scoped = scoped.where(team_id: team_ids) unless team_ids.empty?
    scoped = scoped.where(plan_id: plan_ids) unless plan_ids.empty?
    scoped = scoped.order("starts_at DESC")
    scoped
  end

  def fetch_records
    rslt = all_records
    rslt = rslt.take(limit.to_i) if limit
    rslt
  end

  def today
    Date.today
  end
end
