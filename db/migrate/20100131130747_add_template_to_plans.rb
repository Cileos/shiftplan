class AddTemplateToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :template, :boolean
  end

  def self.down
    remove_column :plans, :template
  end
end
