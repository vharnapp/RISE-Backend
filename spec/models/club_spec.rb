require 'rails_helper'

RSpec.describe Club, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'associations' do
    it { is_expected.to have_many(:teams) }
  end

  context '#fee' do
    let!(:club) { FactoryGirl.create(:club, skip_subscription: true) }
    let!(:team1) { FactoryGirl.create(:team, name: 'Team 1', club: club) }
    let!(:team2) { FactoryGirl.create(:team, name: 'Team 2', club: club) }
    let!(:subscription) do
      FactoryGirl.create(:subscription, club: club, price: 10)
    end
    let!(:enrollment) do
      FactoryGirl.create(:enrollment, team: team1, subscription: subscription)
      FactoryGirl.create(:enrollment, team: team2, subscription: subscription)
    end

    context '2 teams with 5 players each' do
      it 'calculates the fee at $100 when the price is $10/player' do
        expect(club.fee).to eq(200.0)
      end
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
