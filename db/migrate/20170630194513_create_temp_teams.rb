class CreateTempTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :temp_teams do |t|
      t.string :name
      t.integer :num_players
      t.string :coach_first_name
      t.string :coach_last_name
      t.string :coach_email
      t.references :club, foreign_key: true, index: true

      t.timestamps
    end
  end
end
