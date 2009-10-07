class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans, :force => true do |t|
      t.belongs_to :account
      
      t.string   :name
      t.datetime :start
      t.datetime :end
      t.integer  :duration

      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
