class CreateExerciseWorkouts < ActiveRecord::Migration[5.1]
  def change
    create_table :exercise_workouts do |t|
      t.references :exercise, foreign_key: true
      t.references :workout, foreign_key: true

      t.timestamps
    end
  end
end
