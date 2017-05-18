require 'rails_helper'

RSpec.describe DeviseCustomizations::SessionsController, type: :request do
  let(:user) { create(:user) }

  describe '#destroy' do
    context 'from HTML web page' do
      it 'signs out successfully' do
        sign_in(user)
        get destroy_user_session_path
        expect(response).to be_redirect

        txt = 'Signed out successfully.'
        expect(flash[:notice]).to eq(txt)
      end
    end
  end
end
