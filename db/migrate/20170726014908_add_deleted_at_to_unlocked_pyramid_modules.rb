class AddDeletedAtToUnlockedPyramidModules < ActiveRecord::Migration[5.1]
  def change
    add_column :unlocked_pyramid_modules, :deleted_at, :datetime
    add_column :phase_attempts, :deleted_at, :datetime
  end
end
