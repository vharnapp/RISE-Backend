class AddDeletedAtToPyramidModules < ActiveRecord::Migration[5.1]
  def change
    add_column :affiliations, :deleted_at, :datetime
    add_index :affiliations, :deleted_at

    add_column :clubs, :deleted_at, :datetime
    add_index :clubs, :deleted_at

    add_column :exercises, :deleted_at, :datetime
    add_index :exercises, :deleted_at

    add_column :exercise_workouts, :deleted_at, :datetime
    add_index :exercise_workouts, :deleted_at

    add_column :phases, :deleted_at, :datetime
    add_index :phases, :deleted_at

    add_column :pyramid_modules, :deleted_at, :datetime
    add_index :pyramid_modules, :deleted_at

    add_column :teams, :deleted_at, :datetime
    add_index :teams, :deleted_at

    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at

    add_column :workouts, :deleted_at, :datetime
    add_index :workouts, :deleted_at
  end
end
