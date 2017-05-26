require 'rails_helper'

RSpec.describe Affiliation, type: :model do
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

  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:team) }
  end

  describe 'scopes' do
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

  describe '#title' do
    context 'player' do
      it "displays the affiliate's relationship to the team" do
        expect(player_affiliation.title).to eq('Player')
      end
    end

    context 'coach' do
      it "displays the affiliate's relationship to the team" do
        expect(coach_affiliation.title).to eq('Coach')
      end
    end
  end
end

# == Schema Information
#
# Table name: affiliations
#
#  coach      :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  deleted_at :datetime
#  id         :integer          not null, primary key
#  team_id    :integer
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_affiliations_on_deleted_at  (deleted_at)
#  index_affiliations_on_team_id     (team_id)
#  index_affiliations_on_user_id     (user_id)
#
