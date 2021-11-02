class CreateConfidenceRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :confidence_ratings do |t|
      t.references :user, foreign_key: true, index: true
      t.references :exercise, foreign_key: true, index: true
      t.references :workout, foreign_key: true, index: true
      t.integer :rating, default: 0
      t.boolean :skipped, default: false, null: false

      t.timestamps
    end
  end
end
