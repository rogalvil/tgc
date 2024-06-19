# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :request do
  let(:user) { create :user }
  let(:login_url) { '/api/v1/login' }
  let(:logout_url) { '/api/v1/logout' }

  context 'When logging in' do
    before do
      login_with_api(user)
    end

    it 'returns a token' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end
  end

  context 'When password is missing' do
    before do
      post login_url, params: {
        user: {
          email: user.email,
          name: user.name,
          password: nil
        }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end

  context 'When logging out' do
    before do
      login_with_api(user)
    end

    it 'returns 200' do
      delete logout_url, headers: {
        'Authorization': response.headers['Authorization']
      }
      expect(json['messages']).to include('Logout successfully')
      expect(response).to have_http_status(200)
    end
  end

  context 'When logging out without a token' do
    it 'returns 422' do
      delete logout_url
      expect(json['messages']).to include('Logout was not successful')
      expect(response).to have_http_status(422)
    end
  end
end
