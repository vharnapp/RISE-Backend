class CreatePhases < ActiveRecord::Migration[5.1]
  def change
    create_table :phases do |t|
      t.string :name
      t.references :pyramid_module, foreign_key: true, index: true
      t.boolean :supplemental, default: false, null: false

      t.timestamps
    end
  end
end
