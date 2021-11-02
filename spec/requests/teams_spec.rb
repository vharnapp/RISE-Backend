require 'rails_helper'

RSpec.describe 'Teams', type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:club) { create(:club) }
  let(:team) { create(:team, club: club) }
  let(:invalid_team_attrs) { { name: '' } }

  before { sign_in(admin_user) }

  describe 'GET /clubs/:club_id/teams' do
    it 'redirects to the first team for the given club from the teams index page' do
      get club_teams_path(club)
      expect(response).to be_redirect
    end
  end

  describe 'GET /clubs/:club_id/teams/:id' do
    it 'displays a single team' do
      get club_team_path(club, team)
      expect(response.body).to include(team.name)
    end
  end
end
