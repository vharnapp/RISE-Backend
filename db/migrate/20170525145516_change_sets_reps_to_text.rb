class ChangeSetsRepsToText < ActiveRecord::Migration[5.1]
  def change
    change_column :exercises, :sets, :string
    change_column :exercises, :reps, :string
  end
end
