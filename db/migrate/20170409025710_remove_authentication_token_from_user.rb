class RemoveAuthenticationTokenFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, :authentication_token
    remove_column :users, :authentication_token
  end
end
