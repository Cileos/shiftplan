class SetupSerializer < ApplicationSerializer
  attributes :id,
             :employee_first_name,
             :employee_last_name,
             :account_name,
             :organization_name,
             :time_zone_name,
             :team_names

  def id
    'singleton'
  end
end
