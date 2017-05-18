require 'rails_helper'

RSpec.describe 'Clubs', type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:club) { create(:club) }
  let(:invalid_club_attributes) { { name: '' } }

  before { sign_in(admin_user) }

  describe 'GET /clubs' do
    before { club } # let is lazy, force a club to the db

    it 'lists all clubs' do
      get clubs_path
      expect(response.body).to include(club.name)
    end
  end

  describe 'GET /clubs/:id' do
    it 'displays a single club' do
      get club_path(club)
      expect(response.body).to include(club.name)
    end
  end

  describe 'GET /clubs/new' do
    it 'responds successfully when loading the new action' do
      get new_club_path
      expect(response).to be_success
    end
  end

  describe 'GET /clubs/:id/edit' do
    it 'responds successfully when loading the edit action' do
      get edit_club_path(club.id)
      expect(response).to be_success
    end
  end

  describe 'POST /clubs' do
    let(:valid_club_attributes) { attributes_for(:club) }

    context 'with valid params' do
      it 'creates a new club' do
        expect do
          post clubs_path, params: { club: valid_club_attributes }
        end.to change(Club, :count).by(1)
      end

      it 'redirects to the clubs path' do
        post clubs_path, params: { club: valid_club_attributes }
        expect(response).to redirect_to(clubs_path)
      end
    end

    context 'with invalid params' do
      it "doesn't create club" do
        expect do
          post clubs_path, params: { club: invalid_club_attributes }
        end.to_not change(Club, :count)
      end

      it 'renders the new form with errors' do
        post clubs_path, params: { club: invalid_club_attributes }
        expect(response.body).to include('field_with_errors')
      end
    end
  end

  describe 'PUT /clubs/:id' do
    let(:new_club_attributes) { { name: 'New Name' } }

    context 'with valid params' do
      it 'updates the requested club' do
        put club_path(club), params: { club: new_club_attributes }
        club.reload
        expect(club.name).to eq('New Name')
      end

      it 'redirects to the clubs path' do
        put club_path(club), params: { club: new_club_attributes }
        expect(response).to redirect_to(clubs_path)
      end
    end

    context 'with invalid params' do
      it "doesn't update the club" do
        put club_path(club), params: { club: invalid_club_attributes }
        club_from_db = Club.find(club.id)
        expect(club_from_db).to eq(club)
      end

      it 'renders the edit form with errors' do
        put club_path(club), params: { club: invalid_club_attributes }
        expect(response.body).to include('field_with_errors')
      end
    end
  end

  describe 'DELETE clubs/:id' do
    it 'destroys the requested club' do
      club # let is lazy, force a club to the db
      expect do
        delete club_path(club)
      end.to change(Club, :count).by(-1)
    end

    it 'redirects to the clubs list' do
      delete club_path(club)
      expect(response).to redirect_to(clubs_url)
    end
  end
end
