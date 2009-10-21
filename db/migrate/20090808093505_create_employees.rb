class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.belongs_to :account

      t.string  :first_name
      t.string  :last_name
      t.string  :initials, :limit => 10
      t.date    :birthday
      t.boolean :active, :default => true

      t.string  :email
      t.string  :phone
      t.string  :street
      t.string  :zipcode
      t.string  :city

      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
