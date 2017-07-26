class AddDeletedAtToConfidenceRatings < ActiveRecord::Migration[5.1]
  def change
    add_column :confidence_ratings, :deleted_at, :datetime
  end
end
