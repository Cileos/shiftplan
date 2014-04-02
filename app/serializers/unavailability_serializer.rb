class UnavailabilitySerializer < ApplicationSerializer
  attributes :id,
             :starts_at,
             :ends_at,
             :description,
             :reason,
             :account_ids
end
