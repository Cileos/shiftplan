class UnavailabilitySerializer < ApplicationSerializer
  attributes :id,
             :starts_at,
             :ends_at,
             :description,
             :reason,
             :all_day

  has_one :account
end
