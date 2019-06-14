class AddStringIdToSinglePayments < ActiveRecord::Migration[5.1]
  def change
    add_column :single_payments, :string_id, :string
  end
end
