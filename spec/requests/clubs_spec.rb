require 'rails_helper'

RSpec.describe 'Clubs', type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:club) { create(:club) }
  let(:team) { create(:team, club: club) }
  let(:invalid_club_attributes) { { name: '' } }

  before { sign_in(admin_user) }

  describe 'GET /clubs' do
    before { team } # let is lazy, force a club to the db

    context 'only one club' do
      it 'redirects to the first team for that club' do
        get clubs_path
        expect(response).to be_redirect
      end
    end

    context 'multiple clubs' do
      before { create(:club) }

      it 'lists all clubs' do
        get clubs_path
        expect(response.body).to include(club.name)
      end
    end
  end

  describe 'GET /clubs/:id' do
    it 'displays a single club' do
      get club_path(club)
      expect(response.body).to include(club.name)
    end
  end
end
