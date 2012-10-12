class AddDecriptionToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :description, :text

  end
end
