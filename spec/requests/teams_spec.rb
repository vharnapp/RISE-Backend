require 'rails_helper'

RSpec.describe 'Teams', type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:club) { create(:club) }
  let(:team) { create(:team, club: club) }
  let(:invalid_team_attrs) { { name: '' } }

  before { sign_in(admin_user) }

  describe 'GET /clubs/:club_id/teams/:id' do
    it 'displays a single team' do
      get club_team_path(club, team)
      expect(response.body).to include(team.name)
    end
  end

  describe 'GET /clubs/:club_id/teams/new' do
    it 'responds successfully when loading the new action' do
      get new_club_team_path(club)
      expect(response).to be_success
    end
  end

  describe 'GET /clubs/:club_id/teams/:id/edit' do
    it 'responds successfully when loading the edit action' do
      get edit_club_team_path(club, team.id)
      expect(response).to be_success
    end
  end

  describe 'POST /clubs/:club_id/teams' do
    let(:valid_team_attrs) do
      attributes_for(:team).merge(club_id: club.id)
    end

    context 'with valid params' do
      it 'creates a new team' do
        expect do
          post club_teams_path(club), params: { team: valid_team_attrs }
        end.to change(Team, :count).by(1)
      end

      it 'redirects to the teams path' do
        post club_teams_path(club), params: { team: valid_team_attrs }
        expect(response).to redirect_to(club_path(club))
      end
    end

    context 'with invalid params' do
      it "doesn't create team" do
        expect do
          post club_teams_path(club), params: { team: invalid_team_attrs }
        end.to_not change(Team, :count)
      end

      it 'renders the new form with errors' do
        post club_teams_path(club), params: { team: invalid_team_attrs }
        expect(response.body).to include('field_with_errors')
      end
    end
  end

  describe 'PUT /teams/:id' do
    let(:new_team_attributes) { { name: 'New Name' } }

    context 'with valid params' do
      it 'updates the requested team' do
        put club_team_path(club, team), params: { team: new_team_attributes }
        team.reload
        expect(team.name).to eq('New Name')
      end

      it 'redirects to the team path' do
        put club_team_path(club, team), params: { team: new_team_attributes }
        expect(response).to redirect_to(club_team_path(club, team))
      end
    end

    context 'with invalid params' do
      it "doesn't update the team" do
        put club_team_path(club, team), params: { team: invalid_team_attrs }
        team_from_db = Team.find(team.id)
        expect(team_from_db).to eq(team)
      end

      it 'renders the edit form with errors' do
        put club_team_path(club, team), params: { team: invalid_team_attrs }
        expect(response.body).to include('field_with_errors')
      end
    end
  end

  describe 'DELETE teams/:id' do
    it 'destroys the requested team' do
      team
      expect do
        delete club_team_path(club, team)
      end.to change(Team, :count).by(-1)
    end

    it 'redirects to the teams list' do
      delete club_team_path(club, team)
      expect(response).to redirect_to(club_url(club))
    end
  end
end
