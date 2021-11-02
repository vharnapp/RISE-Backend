class AddThankYouLinkToSinglePayments < ActiveRecord::Migration[5.1]
  def change
    add_column :single_payments, :thank_you_link, :string
  end
end
