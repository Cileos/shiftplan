class Unavailability < ActiveRecord::Base
  include TimeRangeComponentsAccessible
  attr_accessible :employee_id,
                  :starts_at,
                  :ends_at,
                  :start_time,
                  :end_time,
                  :date,
                  :reason,
                  :user_id
end
