class AddDescriptionToSinglePayments < ActiveRecord::Migration[5.1]
  def change
  	add_column :single_payments, :specifications, :text, :default => ''
  	add_column :single_payments, :special_label, :string, :default => ''
  end
end
