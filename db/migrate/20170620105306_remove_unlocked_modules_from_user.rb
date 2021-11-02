class RemoveUnlockedModulesFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :unlocked_pyramid_modules
  end
end
