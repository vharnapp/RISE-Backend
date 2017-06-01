class AddPositionToModels < ActiveRecord::Migration[5.1]
  def change
    add_column :affiliations,      :position, :integer
    add_column :clubs,             :position, :integer
    add_column :exercises,         :position, :integer
    add_column :exercise_workouts, :position, :integer
    add_column :phases,            :position, :integer
    add_column :pyramid_modules,   :position, :integer
    add_column :teams,             :position, :integer
    add_column :users,             :position, :integer
    add_column :workouts,          :position, :integer

    add_column :pyramid_modules,   :level, :integer
    add_column :pyramid_modules,   :prereq, :text, array:true, default: []
  end
end
