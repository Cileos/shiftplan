class CreateQualifications < ActiveRecord::Migration
  def self.up
    create_table :qualifications do |t|
      t.belongs_to :account

      t.string :name
      t.string :color, :limit => 6

      t.timestamps
    end
  end

  def self.down
    drop_table :qualifications
  end
end
