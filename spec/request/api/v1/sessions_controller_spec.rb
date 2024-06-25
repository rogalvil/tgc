# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :request do
  let(:user) { create(:user) }

  describe 'POST /api/v1/login' do
    context 'with valid credentials' do
      before { login_with_api(email: user.email, password: user.password) }

      it 'returns a token' do
        expect(response.headers['Authorization']).to be_present
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with missing password' do
      before { login_with_api(email: user.email, password: nil) }

      it 'returns 401 status' do
        expect(json['errors'][0]['title']).to include('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/logout' do
    context 'with valid token' do
      before { @auth_token = login_with_api(email: user.email, password: user.password) }

      it 'logs out successfully' do
        logout_with_api({ 'Authorization': @auth_token })
        expect(json['messages']).to include('Logout successfully')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'without token' do
      it 'returns 422 status' do
        logout_with_api({})
        expect(json['messages']).to include('Logout was not successful')
        expect(response).to have_http_status(422)
      end
    end
  end
end
