require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'constants' do
    context 'roles' do
      it 'has the admin role' do
        expect(User::ROLES).to eq([:player, :coach, :club_admin, :admin])
      end
    end
  end

  describe 'validations' do
    context 'email' do
      it { is_expected.to validate_presence_of(:email) }
      context 'valid' do
        it { is_expected.to allow_value('email@addresse.foo').for(:email) }
      end
      context 'invalid' do
        it { is_expected.to_not allow_value('foo').for(:email) }
        it { is_expected.to_not allow_value('foo@com').for(:email) }
        it { is_expected.to_not allow_value('@foo.com').for(:email) }
        it { is_expected.to_not allow_value('foo@.com').for(:email) }
      end
    end
    context 'password' do
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_presence_of(:password_confirmation) }
    end
    context 'name' do
      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_presence_of(:last_name) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:affiliations).dependent(:destroy) }
    it { is_expected.to have_many(:teams).through(:affiliations) }
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

  context '#full_name' do
    it 'concatenates the first and last names' do
      user = build(:user)
      expect("#{user.first_name} #{user.last_name}").to eq(user.full_name)
    end
  end

  context '#role_list' do
    it 'lists all the user roles in alphabetical order, comma separated' do
      user = create(:user, :admin)
      user.roles << :coach
      user.save
      expect(user.role_list).to eq('Admin, Coach')
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

  context '#week_view' do
    it 'pulls back pyramid modules that were rated in the last 7 days' do
      user = create(:user)

      # TODAY
      @one = create(:confidence_rating, user: user)

      # YESTERDAY
      travel_to 1.day.ago do
        @two = create(:confidence_rating,  user: user)
      end

      travel_to 3.days.ago do
        @four = create(:confidence_rating,  user: user)
      end

      travel_to 4.days.ago do
        @five = create(:confidence_rating, user: user)
      end

      travel_to 5.days.ago do
        @six = create(:confidence_rating, user: user)
      end

      travel_to 6.days.ago do
        @seven = create(:confidence_rating, user: user)
      end

      week_hash = {
        @one.updated_at.to_date.to_s(:db) =>   @one.workout.phase.pyramid_module.id,
        @two.updated_at.to_date.to_s(:db) =>   @two.workout.phase.pyramid_module.id,
        @four.updated_at.to_date.to_s(:db) =>  @four.workout.phase.pyramid_module.id,
        @five.updated_at.to_date.to_s(:db) =>  @five.workout.phase.pyramid_module.id,
        @six.updated_at.to_date.to_s(:db) =>   @six.workout.phase.pyramid_module.id,
        @seven.updated_at.to_date.to_s(:db) => @seven.workout.phase.pyramid_module.id
      }

      expect(user.week_view).to eq(week_hash)
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  deleted_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  id                     :integer          not null, primary key
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  nickname               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  roles_mask             :integer
#  sign_in_count          :integer          default(0), not null
#  slug                   :string
#  updated_at             :datetime         not null
#  uuid                   :string
#
# Indexes
#
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#
