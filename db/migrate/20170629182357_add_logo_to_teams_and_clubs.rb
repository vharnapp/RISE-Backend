class AddLogoToTeamsAndClubs < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :logo, :string
    add_column :clubs, :logo, :string
  end
end
