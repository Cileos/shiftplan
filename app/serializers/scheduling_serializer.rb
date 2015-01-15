class SchedulingSerializer < ApplicationSerializer
  attributes :id,
             :starts_at,
             :ends_at,
             :all_day

  has_one :employee
  has_one :team

end
