class RemovePositionFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :position
  end
end
