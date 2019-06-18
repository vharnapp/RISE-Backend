class CreateSinglePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :single_payments do |t|
      t.string :name
      t.float :price

      t.timestamps
    end
  end
end
