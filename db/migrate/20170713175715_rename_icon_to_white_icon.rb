class RenameIconToWhiteIcon < ActiveRecord::Migration[5.1]
  def change
    rename_column :pyramid_modules, :icon, :icon_white
    add_column :pyramid_modules, :icon_black, :string
  end
end
