FactoryGirl.define do
  factory :club do
    name                 { Faker::Name.club_name }
    address_city         { Faker::Address.city }
    address_line1        { Faker::Address.street_address }
    address_line2        { Faker::Address.secondary_address }
    address_state        { Faker::Address.state_abbr }
    address_zip          { Faker::Address.zip_code }
    contact_email        { Faker::Internet.email }
    contact_first_name   { Faker::Name.first_name }
    contact_last_name    { Faker::Name.last_name }
    contact_phone        { Faker::PhoneNumber.phone_number }

    transient do
      subscription_count 1
      skip_subscription false
    end

    after(:create) do |club, evaluator|
      next if evaluator.skip_subscription
      create_list(:subscription, evaluator.try(:subscription_count) || 1, club: club)
    end
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
#  welcome_message    :text
#
# Indexes
#
#  index_clubs_on_deleted_at  (deleted_at)
#  index_clubs_on_slug        (slug) UNIQUE
#
