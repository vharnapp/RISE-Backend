FactoryGirl.define do
  factory :club do
    name 'Webdev'
  end
end

# == Schema Information
#
# Table name: clubs
#
#  address_city       :string
#  address_line1      :string
#  address_line2      :string
#  address_state      :string
#  address_zip        :string
#  contact_email      :string
#  contact_first_name :string
#  contact_last_name  :string
#  contact_phone      :string
#  created_at         :datetime         not null
#  deleted_at         :datetime
#  id                 :integer          not null, primary key
#  logo               :string
#  name               :string
#  position           :integer
#  slug               :string
#  teams_csv          :string
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_clubs_on_deleted_at  (deleted_at)
#  index_clubs_on_slug        (slug) UNIQUE
#
