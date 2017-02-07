require 'rails_helper'

describe 'Retrieve user list from API', type: :request do
  context 'with token authentication via query params' do
    it 'returns status code 200' do
      user = create(:user, :admin)

      get admin_users_url(user_email: user.email,
                          user_token: user.authentication_token), as: :json

      expect(response.status).to eq 200
    end

    it 'returns valid user JSON matching schema' do
      user = create(:user, :admin)

      get admin_users_url(user_email: user.email,
                          user_token: user.authentication_token), as: :json

      expect(response).to match_response_schema('user')
    end
  end

  context 'with token authentication via request headers' do
    it 'returns status code 200' do
      user = create(:user, :admin)
      token_header_params = { 'X-User-Email': user.email,
                              'X-User-Token': user.authentication_token }

      get admin_users_url, headers: token_header_params, as: :json

      expect(response.status).to eq 200
    end
    it 'returns value user JSON matching schema' do
      user = create(:user, :admin)
      token_header_params = { 'X-User-Email': user.email,
                              'X-User-Token': user.authentication_token }

      get admin_users_url, headers: token_header_params, as: :json

      expect(response).to match_response_schema('user')
    end
  end
end
