FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    uuid { SecureRandom.uuid }
    password 'asdfjkl123'
    password_confirmation 'asdfjkl123'
    sequence(:email) { |n| "user_#{n}@example.com" }

    trait :admin do
      roles [:admin]
      first_name 'Admin'
      last_name 'User'
      email 'admin@example.com'
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  created_at               :datetime         not null
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :inet
#  deleted_at               :datetime
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  first_name               :string
#  id                       :integer          not null, primary key
#  last_name                :string
#  last_sign_in_at          :datetime
#  last_sign_in_ip          :inet
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string
#  roles_mask               :integer
#  sign_in_count            :integer          default(0), not null
#  slug                     :string
#  unlocked_pyramid_modules :text             default([]), is an Array
#  updated_at               :datetime         not null
#  uuid                     :string
#
# Indexes
#
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#
