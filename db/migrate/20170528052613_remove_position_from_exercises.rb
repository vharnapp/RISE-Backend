class RemovePositionFromExercises < ActiveRecord::Migration[5.1]
  def change
    remove_column :exercises, :position
  end
end
