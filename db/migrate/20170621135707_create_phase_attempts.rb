class CreatePhaseAttempts < ActiveRecord::Migration[5.1]
  def change
    create_table :phase_attempts do |t|
      t.references :user, foreign_key: true
      t.references :phase, foreign_key: true
      t.integer :count

      t.timestamps
    end
  end
end
