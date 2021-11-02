class CreateUnlockedPyramidModules < ActiveRecord::Migration[5.1]
  def change
    create_table :unlocked_pyramid_modules do |t|
      t.references :user, foreign_key: true, index: true
      t.references :pyramid_module, foreign_key: true, index: true
      t.text :completed_phases, array: true, default: []

      t.timestamps
    end
  end
end
