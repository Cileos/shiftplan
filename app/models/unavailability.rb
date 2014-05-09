class Unavailability < ActiveRecord::Base
  include TimeRangeComponentsAccessible
  attr_accessible :employee_id,
                  :starts_at,
                  :ends_at,
                  :start_time,
                  :end_time,
                  :date,
                  :reason,
                  :account_ids,
                  :description

  belongs_to :user
  belongs_to :employee

  before_validation :set_user_from_employee, on: :create

  def accounts
    Account.where id: account_ids
  end

  # TODO ability to assign the account_ids?

private

  def set_user_from_employee
    if employee
      self.user ||= employee.user
    end
  end
end
