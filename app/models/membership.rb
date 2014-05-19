class Membership < ActiveRecord::Base
  Roles = %w(owner planner)

  belongs_to :organization
  belongs_to :employee

  validates_uniqueness_of :employee_id, scope: :organization_id
  validates_inclusion_of :role, in: Roles, allow_blank: true

  def to_s
    owwt = organization_weekly_working_time.present? ? "(#{organization_weekly_working_time})" : ''
    %Q~<#{self.class} #{employee.name.inspect} in #{organization.name.inspect} #{owwt}>~
  end

  def inspect
    to_s
  end

  Roles.each do |role|
    define_method("#{role}?") { self.role == role }
  end
end
