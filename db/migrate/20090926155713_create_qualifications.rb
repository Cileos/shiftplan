class CreateQualifications < ActiveRecord::Migration
  def self.up
    create_table :qualifications do |t|
      t.column :name, :string
      t.column :color, :string, :limit => 6
    end
  end

  def self.down
    drop_table :qualifications
  end
end
