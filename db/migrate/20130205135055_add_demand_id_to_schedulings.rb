class AddDemandIdToSchedulings < ActiveRecord::Migration
  def change
    add_column :schedulings, :demand_id, :integer
    add_index  :schedulings, :demand_id
  end
end
