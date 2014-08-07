class SetupSerializer < ApplicationSerializer
  attributes :id,
             :employee_first_name,
             :employee_last_name,
             :account_name,
             :organization_name,
             :team_names
end
