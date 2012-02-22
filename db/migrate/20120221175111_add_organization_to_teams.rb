class AddOrganizationToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :organization_id, :integer
  end
end
