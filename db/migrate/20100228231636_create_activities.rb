class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities, :force => true do |t|
      t.string     :action
      t.text       :changes
      t.belongs_to :object, :polymorphic => true
      t.belongs_to :user
      t.string     :user_name
      t.datetime   :started_at
      t.datetime   :finished_at
      t.datetime   :aggregated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end