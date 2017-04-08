require 'rails_helper'

RSpec.describe Admin::UsersController, type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:user) { create(:user) }

  context 'NOT authenticated' do
    it 'redirects to sign in page with an alert' do
      get admin_users_path
      expect(response).to be_redirect

      txt = 'You need to sign in or sign up before continuing.'
      expect(flash[:alert]).to eq(txt)
    end
  end

  context 'authenticated' do
    before { sign_in(admin_user) }

    describe '#index' do
      context 'authenticated' do
        context 'admin' do
          it 'loads all users in the browser' do
            get admin_users_path
            expect(response).to be_success
          end

          it 'lists all users as json' do
            token_header_params = {
              'X-User-Email': admin_user.email,
              'X-User-Token': admin_user.authentication_token,
            }

            get admin_users_url, headers: token_header_params, as: :json

            expect(response.content_type).to eq('application/json')
            expect(response).to have_http_status(:success)
          end
        end

        context 'user' do
          it 'redirects with an alert that you need to be an admin' do
            sign_in(user)
            get admin_users_path
            expect(response).to be_redirect

            txt = 'You must be an admin to perform that action'
            expect(flash[:alert]).to eq(txt)
          end
        end
      end
    end

    describe 'GET /admin/users/new' do
      it 'responds successfully when loading the new action' do
        get new_admin_user_path
        expect(response).to be_success
      end
    end

    describe 'GET /admin/users/:id/edit' do
      it 'responds successfully when loading the edit action' do
        get edit_admin_user_path(user.id)
        expect(response).to be_success
      end
    end

    describe 'POST /admin/users' do
      let(:club) { create(:club) }
      let(:team1) { create(:team, club: club) }
      let(:valid_user_attributes) do
        attributes_for(:user).except(:uuid).merge(team_ids: [''])
      end
      let(:invalid_user_attributes) do
        attributes_for(:user).except(:uuid).except(:first_name)
      end

      context 'with valid params' do
        it 'creates a new user' do
          expect do
            post admin_users_path, params: { user: valid_user_attributes }
          end.to change(User, :count).by(1)
        end

        context 'with a team specified' do
          before { valid_user_attributes.merge!(team_ids: [team1.id]) }

          context 'for a player' do
            it 'adds a team affiliation' do
              params = { user: valid_user_attributes, player: true }
              expect do
                post admin_users_path, params: params
              end.to change(Affiliation, :count).by(1)

              expect(Affiliation.last.coach?).to eq(false)
            end
          end

          context 'for a coach' do
            it 'adds a team affiliation' do
              params = { user: valid_user_attributes, coach: true }
              expect do
                post admin_users_path, params: params
              end.to change(Affiliation, :count).by(1)

              expect(Affiliation.last.coach?).to eq(true)
            end
          end

          it 'redirects to the clubs team path' do
            post admin_users_path, params: { user: valid_user_attributes }
            expect(response).to redirect_to(club_team_path(club, team1))
          end
        end

        context 'withOUT a team specified' do
          it 'redirects to the clubs team path' do
            post admin_users_path, params: { user: valid_user_attributes }
            expect(response).to redirect_to(admin_users_path)
          end
        end
      end

      context 'with invalid params' do
        it "doesn't create a user" do
          expect do
            post admin_users_path, params: { user: invalid_user_attributes }
          end.to_not change(User, :count)
        end

        it 'renders the new form with errors' do
          post admin_users_path, params: { user: invalid_user_attributes }
          expect(response.body).to include('field_with_errors')
        end
      end
    end

    describe 'PUT /clubs/:id' do
      context 'with valid params' do
        let(:updated_user_attributes) { { first_name: 'NewName' } }

        it 'updates the requested user' do
          put admin_user_path(user), params: { user: updated_user_attributes }
          user.reload
          expect(user.first_name).to eq('NewName')
        end

        it 'redirects to the admin users path' do
          put admin_user_path(user), params: { user: updated_user_attributes }
          expect(response).to redirect_to(admin_users_path)
        end
      end

      context 'with invalid params' do
        let(:invalid_updated_u_attrs) { { first_name: '' } }

        it "doesn't update the user" do
          put admin_user_path(user), params: { user: invalid_updated_u_attrs }
          user_from_db = User.find(user.id)
          expect(user_from_db).to eq(user)
        end

        it 'renders the edit form with errors' do
          put admin_user_path(user), params: { user: invalid_updated_u_attrs }
          expect(response.body).to include('field_with_errors')
        end
      end
    end

    describe 'DELETE /admin/users/:id' do
      it 'destroys the requested user' do
        user # let is lazy, force a user to the db
        expect do
          delete admin_user_path(user)
        end.to change(User, :count).by(-1)
      end

      it 'redirects to the user list' do
        delete admin_user_path(user)
        expect(response).to redirect_to(admin_users_url)
      end
    end

    describe '#impersonate' do
      it 'changes the current user from admin to the specified user' do
        sign_in(admin_user)
        get impersonate_admin_user_path(user)
        expect(controller.current_user).to eq(user)
      end
    end

    describe '#stop_impersonating' do
      it 'returns the current_user to the admin user' do
        sign_in(admin_user)
        get impersonate_admin_user_path(user)
        expect(controller.current_user).to eq(user)
        get stop_impersonating_admin_users_path
        expect(controller.current_user).to eq(admin_user)
      end
    end
  end
end
