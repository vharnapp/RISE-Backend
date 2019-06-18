class CreateArchievedUserPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :archieved_user_payments do |t|
      t.references :user, foreign_key: true
      t.references :single_payment
      t.string :payment_name
      t.float :payment_price
      t.string :payment_stripe_id

      t.timestamps
    end
  end
end
