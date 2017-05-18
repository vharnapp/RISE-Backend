class AddSlugs < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true

    add_column :clubs, :slug, :string
    add_index :clubs, :slug, unique: true

    add_column :teams, :slug, :string
    add_index :teams, :slug, unique: true
  end
end
