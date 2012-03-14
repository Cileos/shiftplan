class PromotePlannersToOwners < ActiveRecord::Migration
  def up
    execute <<-EOSQL
      UPDATE users SET roles =  replace(roles, 'planner', 'owner');
    EOSQL
  end

  def down
    # yes, naive.
    execute <<-EOSQL
      UPDATE users SET roles =  replace(roles, 'owner', 'planner');
    EOSQL
  end
end
