class Membership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :employee

  validates_uniqueness_of :employee_id, scope: :organization_id

  def to_s
    owwt = organization_weekly_working_time.present? ? "(#{organization_weekly_working_time})" : ''
    %Q~<#{self.class} #{employee.name.inspect} in #{organization.name.inspect} #{owwt}>~
  end

  def inspect
    to_s
  end
end
