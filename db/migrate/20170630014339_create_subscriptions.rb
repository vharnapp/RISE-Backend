class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.date :start_date
      t.date :end_date
      t.references :club, foreign_key: true, index: true
      t.decimal :price

      t.timestamps
    end
  end
end
