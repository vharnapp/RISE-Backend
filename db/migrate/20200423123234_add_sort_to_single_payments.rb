class AddSortToSinglePayments < ActiveRecord::Migration[5.1]
  def change
  	add_column :single_payments, :sort, :integer, :default => 1
  end
end
