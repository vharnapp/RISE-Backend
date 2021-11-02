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

    trait :coach do
      roles [:coach]
      first_name 'Coach'
    end

    trait :player do
      roles [:player]
      first_name 'Player'
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  avatar                 :string
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  deleted_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  id                     :integer          not null, primary key
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_id          :integer
#  invited_by_type        :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  nickname               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  roles_mask             :integer
#  sign_in_count          :integer          default(0), not null
#  single_payment_id      :integer
#  slug                   :string
#  stripe_customer_id     :string
#  stripe_payment_id      :string
#  updated_at             :datetime         not null
#  uuid                   :string
#
# Indexes
#
#  index_users_on_deleted_at                         (deleted_at)
#  index_users_on_email                              (email) UNIQUE
#  index_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_users_on_invitations_count                  (invitations_count)
#  index_users_on_invited_by_id                      (invited_by_id)
#  index_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_users_on_reset_password_token               (reset_password_token) UNIQUE
#  index_users_on_slug                               (slug) UNIQUE
#
