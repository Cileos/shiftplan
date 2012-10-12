class AddEndTimeToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :ends_at, :datetime

  end
end
