require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'GET /index' do
    it 'gets the index' do
      user = create(:user, :admin)
      token_header_params = { 'X-User-Email': user.email,
                              'X-User-Token': user.authentication_token }
      get api_v1_users_path, headers: token_header_params, as: :json
      user_response = json_response
      expect(user_response[:data].first[:attributes][:email]).to eq(user.email)
    end
  end
end
