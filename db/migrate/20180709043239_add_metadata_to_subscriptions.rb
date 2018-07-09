class AddMetadataToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :metadata, :json
  end
end
