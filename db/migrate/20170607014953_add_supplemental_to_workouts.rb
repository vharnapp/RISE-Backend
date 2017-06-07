class AddSupplementalToWorkouts < ActiveRecord::Migration[5.1]
  def change
    add_column :workouts, :supplemental, :boolean, default: false, nil: false
  end
end
