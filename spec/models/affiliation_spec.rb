require 'rails_helper'

RSpec.describe Affiliation, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:team) }
  end

  describe 'scopes' do
    let(:club) { create(:club) }
    let(:team) { create(:team, club: club) }
    let(:player) { create(:user) }
    let(:coach) { create(:user) }
    let(:player_affiliation) do
      create(:affiliation, user: player, team: team, coach: false)
    end
    let(:coach_affiliation) do
      create(:affiliation, user: coach, team: team, coach: true)
    end

    before do
      player_affiliation
      coach_affiliation
    end

    it 'can filter users based on player' do
      expect(described_class.players.map(&:coach).uniq).to eq([false])
    end

    it 'can filter users based on coach' do
      expect(described_class.coaches.map(&:coach).uniq).to eq([true])
    end
  end
end

# == Schema Information
#
# Table name: affiliations
#
#  coach      :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  team_id    :integer
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_affiliations_on_team_id  (team_id)
#  index_affiliations_on_user_id  (user_id)
#
