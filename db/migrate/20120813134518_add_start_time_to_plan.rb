class AddStartTimeToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :starts_at, :datetime

  end
end
