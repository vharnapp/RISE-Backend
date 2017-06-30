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
  end
end
