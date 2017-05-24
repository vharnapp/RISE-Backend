class CreateExercises < ActiveRecord::Migration[5.1]
  def change
    create_table :exercises do |t|
      t.string :name
      t.text :description
      t.integer :sets
      t.integer :reps
      t.string :rest
      t.attachment :video
      t.attachment :keyframe

      t.timestamps
    end
  end
end
