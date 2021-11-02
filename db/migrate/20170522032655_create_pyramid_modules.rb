class CreatePyramidModules < ActiveRecord::Migration[5.1]
  def change
    create_table :pyramid_modules do |t|
      t.string :name
      t.text :description
      t.integer :track
      t.attachment :video
      t.attachment :keyframe

      t.timestamps
    end
  end
end
