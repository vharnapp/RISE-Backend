class CreateAffiliateCodePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :affiliate_code_purchases do |t|
    	t.references :affiliate_discount_code, foreign_key: true, index: true
    	t.references :club, foreign_key: true, index: true
    	t.references :user, foreign_key: true, index: true
    	t.string :program_name, null: false, default: ""
    	t.float :full_price, null: false, default: 0
    	t.float :discount, null: false, default: 0
    	t.float :discounted_price, null: false, default: 0
    	t.float :affiliate_revenue, null: false, default: 0
      t.timestamps
    end
  end
end
