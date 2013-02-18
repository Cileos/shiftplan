class LinkQualificationsToAccounts < ActiveRecord::Migration
  def up
    execute <<-EOSQL
      UPDATE qualifications SET account_id = org.account_id
      FROM (
        SELECT id, account_id
        FROM organizations
      ) AS org
      WHERE qualifications.organization_id = org.id
    EOSQL
  end
end
