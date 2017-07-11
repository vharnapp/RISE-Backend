class AddIconToPyramidModule < ActiveRecord::Migration[5.1]
  def change
    add_column :pyramid_modules, :icon, :string
  end
end
