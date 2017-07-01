class AddTeamsCsvToClubs < ActiveRecord::Migration[5.1]
  def change
    add_column :clubs, :teams_csv, :string
  end
end
