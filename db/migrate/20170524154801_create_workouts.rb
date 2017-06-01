class CreateWorkouts < ActiveRecord::Migration[5.1]
  def change
    create_table :workouts do |t|
      t.string :name
      t.references :phase, foreign_key: true, index: true

      t.timestamps
    end
  end
end
