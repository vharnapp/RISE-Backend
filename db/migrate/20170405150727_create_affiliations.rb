class CreateAffiliations < ActiveRecord::Migration[5.1]
  def change
    create_table :affiliations do |t|
      t.references :user, foreign_key: true
      t.references :team, foreign_key: true
      t.boolean :coach, null: false, default: false

      t.timestamps
    end
  end
end
