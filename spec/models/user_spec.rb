require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'constants' do
    context 'roles' do
      it 'has the admin role' do
        expect(User::ROLES).to eq([:admin])
      end
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:password_confirmation) }
  end

  context '#tester?' do
    ['example.com', 'headway.io'].each do |domain|
      it "an email including the #{domain} domain is a tester" do
        user = build(:user, email: "asdf@#{domain}")
        expect(user.tester?).to eq(true)
      end
    end

    it 'an email including the gmail.com domain is NOT a tester' do
      user = build(:user, email: 'asdf@gmail.com')
      expect(user.tester?).to eq(false)
    end
  end

  context 'new user creation' do
    it 'ensures uniqueness of the uuid' do
      allow(User).to receive(:exists?).and_return(true, false)

      expect do
        create(:user)
      end.to change { User.count }.by(1)

      expect(User).to have_received(:exists?).exactly(2).times
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  authentication_token   :string(30)
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  id                     :integer          not null, primary key
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  roles_mask             :integer
#  sign_in_count          :integer          default(0), not null
#  updated_at             :datetime         not null
#  uuid                   :string
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
