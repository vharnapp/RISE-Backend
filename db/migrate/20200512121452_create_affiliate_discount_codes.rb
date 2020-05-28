class CreateAffiliateDiscountCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :affiliate_discount_codes do |t|
      t.string :code, null: false, default: "code123"
    	t.references :club, foreign_key: true, index: true
    	t.references :team, foreign_key: true, index: true
      t.string :contact_name, null: false, default: ""
      t.string :contact_email, null: false, default: ""
      t.string :payment_info, null: false, default: ""
      t.integer :affiliation_rate, null: false, default: 0
      t.string :discount_type, null: false, default: "amount", comment: "accepted values: value or percent"
      t.integer :discount, null: false, default: 0
      t.integer :max_users, null: false, default: 1
      t.date :start_date, null: true
      t.date :end_date, null: true

      t.timestamps
    end
  end
end
