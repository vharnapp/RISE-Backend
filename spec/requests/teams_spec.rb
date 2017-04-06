require 'rails_helper'

RSpec.describe 'Teams', type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:club) { create(:club) }
  let(:team) { create(:team, club: club) }
  let(:invalid_team_attributes) { { name: '' } }

  before { sign_in(admin_user) }

  describe 'GET /teams' do
    it 'lists all teams' do
      team
      get teams_path
      expect(response.body).to include(team.name)
    end
  end

  describe 'GET /teams/:id' do
    it 'displays a single team' do
      get team_path(team)
      expect(response.body).to include(team.name)
    end
  end

  describe 'GET /teams/new' do
    it 'loads the new template' do
      get new_team_path
      expect(response).to be_success
    end
  end

  describe 'GET /teams/:id/edit' do
    it 'loads the edit template' do
      get edit_team_path(team.id)
      expect(response).to be_success
    end
  end

  describe 'POST /teams' do
    let(:valid_team_attributes) do
      attributes_for(:team).merge(club_id: club.id)
    end

    context 'with valid params' do
      it 'creates a new team' do
        expect do
          post teams_path, params: { team: valid_team_attributes }
        end.to change(Team, :count).by(1)
      end

      it 'redirects to the teams path' do
        post teams_path, params: { team: valid_team_attributes }
        expect(response).to redirect_to(teams_path)
      end
    end

    context 'with invalid params' do
      it "doesn't create team" do
        expect do
          post teams_path, params: { team: invalid_team_attributes }
        end.to_not change(Team, :count)
      end

      it 'renders the new form with errors' do
        post teams_path, params: { team: invalid_team_attributes }
        expect(response.body).to include('field_with_errors')
      end
    end
  end

  describe 'PUT /teams/:id' do
    let(:new_team_attributes) { { name: 'New Name' } }

    context 'with valid params' do
      it 'updates the requested team' do
        put team_path(team), params: { team: new_team_attributes }
        team.reload
        expect(team.name).to eq('New Name')
      end

      it 'redirects to the teams path' do
        put team_path(team), params: { team: new_team_attributes }
        expect(response).to redirect_to(teams_path)
      end
    end

    context 'with invalid params' do
      it "doesn't update the team" do
        put team_path(team), params: { team: invalid_team_attributes }
        team_from_db = Team.find(team.id)
        expect(team_from_db).to eq(team)
      end

      it 'renders the edit form with errors' do
        put team_path(team), params: { team: invalid_team_attributes }
        expect(response.body).to include('field_with_errors')
      end
    end
  end

  describe 'DELETE teams/:id' do
    it 'destroys the requested team' do
      team
      expect do
        delete team_path(team)
      end.to change(Team, :count).by(-1)
    end

    it 'redirects to the teams list' do
      delete team_path(team)
      expect(response).to redirect_to(teams_url)
    end
  end
end
