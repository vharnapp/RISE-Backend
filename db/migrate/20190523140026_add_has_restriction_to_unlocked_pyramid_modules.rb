class AddHasRestrictionToUnlockedPyramidModules < ActiveRecord::Migration[5.1]
  def change
    add_column :unlocked_pyramid_modules, :has_restriction, :integer, :default => 0
  end
end
