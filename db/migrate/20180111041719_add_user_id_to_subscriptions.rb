class AddUserIdToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_reference :subscriptions, :user, index: true, foreign_key: true
  end
end
