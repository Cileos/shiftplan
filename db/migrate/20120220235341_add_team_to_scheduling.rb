class AddTeamToScheduling < ActiveRecord::Migration
  def change
    add_column :schedulings, :team_id, :integer
  end
end
