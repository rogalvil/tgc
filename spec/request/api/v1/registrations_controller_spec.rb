# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :request do
  let(:user) { build :user }
  let(:existing_user) { create :user }
  let(:signup_url) { '/api/v1/signup' }

  context 'When creating a new user' do
    before do
      user_params = {
        email: user.email,
        name: user.name,
        password: 'fakepassword',
        password_confirmation: 'fakepassword'
      }
      post signup_url, params: {
        user: user_params
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns a token' do

      expect(response.headers['Authorization']).to be_present
    end

    it 'returns the user email' do
      expect(json['user']['data']['attributes']['email']).to eq(user.email)
    end
  end

  context 'When an email already exists' do
    before do
      post signup_url, params: {
        user: {
          email: existing_user.email,
          name: user.name,
          password: 'fakepassword',
          password_confirmation: 'fakepassword'
        }
      }
    end

    it 'returns 422' do
      expect(response.status).to eq(422)
    end
  end
end
