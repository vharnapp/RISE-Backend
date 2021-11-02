require 'rails_helper'
require 'base64'

describe 'Devise Basic Auth to receive token', type: :request do
  let(:user) { create(:user) }

  context 'POST /api/v1/sign_in' do
    let(:auth_basic) do
      'Basic ' + Base64.encode64("#{user.email}:#{user.password}").chomp
    end

    it 'returns a valid auth token' do
      post api_v1_sign_in_path, headers: {
        'Authorization': auth_basic,
      }, as: :json

      json_response = JSON.parse(response.body)
      token = Tiddle::TokenIssuer.build.find_token(
        user,
        json_response['meta']['authentication_token'],
      )

      expect(token.body).to eq(user.authentication_tokens.last.body)
    end
  end

  context 'GET /api/v1/sign_out' do
    it 'destroys the user auth token' do
      authenticate(user)

      expect do
        get api_v1_sign_out_path, headers: {
          'X-User-Email': user.email,
          'X-User-Token': @authentication_token,
        }, as: :json
      end.to change(AuthenticationToken, :count).by(-1)
    end
  end
end
