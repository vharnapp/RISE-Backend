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

    add_column :affiliations,      :level, :integer
    add_column :clubs,             :level, :integer
    add_column :exercises,         :level, :integer
    add_column :exercise_workouts, :level, :integer
    add_column :phases,            :level, :integer
    add_column :pyramid_modules,   :level, :integer
    add_column :teams,             :level, :integer
    add_column :users,             :level, :integer
    add_column :workouts,          :level, :integer

    add_column :affiliations,      :prereq, :text, array:true, default: []
    add_column :clubs,             :prereq, :text, array:true, default: []
    add_column :exercises,         :prereq, :text, array:true, default: []
    add_column :exercise_workouts, :prereq, :text, array:true, default: []
    add_column :phases,            :prereq, :text, array:true, default: []
    add_column :pyramid_modules,   :prereq, :text, array:true, default: []
    add_column :teams,             :prereq, :text, array:true, default: []
    add_column :users,             :prereq, :text, array:true, default: []
    add_column :workouts,          :prereq, :text, array:true, default: []
  end
end
