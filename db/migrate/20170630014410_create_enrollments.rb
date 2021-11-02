class CreateEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :enrollments do |t|
      t.references :team, foreign_key: true, index: true
      t.references :subscription, foreign_key: true, index: true

      t.timestamps
    end
  end
end
