class AddUnlockedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :unlocked_pyramid_modules, :text, array:true, default: []
  end
end
