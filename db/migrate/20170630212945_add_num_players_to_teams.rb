class AddNumPlayersToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :num_players, :integer
  end
end
