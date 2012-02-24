class AddShortcutToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :shortcut, :string
  end
end
