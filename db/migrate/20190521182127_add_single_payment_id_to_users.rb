class AddSinglePaymentIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :single_payment_id, :integer
  end
end
