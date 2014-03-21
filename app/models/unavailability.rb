class Unavailability < ActiveRecord::Base
  attr_accessible :employee_id, :ends_at, :starts_at, :user_id
end
