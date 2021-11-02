class AddWelcomeMessageToClubs < ActiveRecord::Migration[5.1]
  def change
    add_column :clubs, :welcome_message, :text
  end
end
