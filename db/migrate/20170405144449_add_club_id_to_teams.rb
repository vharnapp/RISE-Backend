class AddClubIdToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :club_id, :integer
    add_foreign_key :teams, :clubs
  end
end
