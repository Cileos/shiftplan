class AddQualificationIdToSchedulings < ActiveRecord::Migration
  def change
    add_column :schedulings, :qualification_id, :integer
    add_index  :schedulings, :qualification_id
  end
end
