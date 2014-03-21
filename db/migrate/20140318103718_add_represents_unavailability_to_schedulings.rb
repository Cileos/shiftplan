class AddRepresentsUnavailabilityToSchedulings < ActiveRecord::Migration
  def change
    add_column :schedulings, :represents_unavailability, :boolean
  end
end
