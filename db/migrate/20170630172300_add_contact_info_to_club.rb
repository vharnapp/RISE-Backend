class AddContactInfoToClub < ActiveRecord::Migration[5.1]
  def change
    add_column :clubs, :contact_first_name, :string
    add_column :clubs, :contact_last_name, :string
    add_column :clubs, :contact_email, :string
    add_column :clubs, :contact_phone, :string
    add_column :clubs, :address_line1, :string
    add_column :clubs, :address_line2, :string
    add_column :clubs, :address_city, :string
    add_column :clubs, :address_state, :string
    add_column :clubs, :address_zip, :string
  end
end
