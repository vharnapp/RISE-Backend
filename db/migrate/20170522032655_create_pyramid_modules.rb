class CreatePyramidModules < ActiveRecord::Migration[5.1]
  def change
    create_table :pyramid_modules do |t|
      t.string :name
      t.text :description
      t.enum :track

      t.timestamps
    end
  end
end
