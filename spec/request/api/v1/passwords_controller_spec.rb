# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :request do
  let(:user) { create(:user) }

  describe 'POST /api/v1/password' do
    it 'sends reset password instructions' do
      post '/api/v1/password', params: { user: { email: user.email } }
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to include(user.email)
      expect(email.subject).to eq('Reset password instructions')
      expect(email.body.encoded).to include('Reset token:')
      expect(json['messages']).to include('Instructions have been sent to your email with the reset token')
      expect(response).to have_http_status(:ok)
    end

    it 'returns an error when email is invalid' do
      post '/api/v1/password', params: { user: { email: 'invalid@example.com' } }
      expect(json['messages']).to include('Email not found')
      expect(ActionMailer::Base.deliveries.count).to eq(0)
      expect(response).to have_http_status(422)
    end
  end

  describe 'PUT /api/v1//password' do
    let!(:reset_token) do
      user.send_reset_password_instructions
    end

    it 'resets the password' do
      reset_params = {
        user: {
          reset_password_token: reset_token,
          password: 'newpassword',
          password_confirmation: 'newpassword'
        }
      }
      put '/api/v1/password', params: reset_params
      expect(json['messages']).to include('Password has been successfully changed')
      expect(response).to have_http_status(:ok)
    end

    it 'returns an error when token is invalid' do
      invalid_reset_params = {
        user: {
          reset_password_token: 'invalid',
          password: 'newpassword',
          password_confirmation: 'newpassword'
        }
      }
      put '/api/v1/password', params: invalid_reset_params
      expect(json['messages']).to include('Reset password token is invalid')
      expect(response).to have_http_status(422)
    end
  end
end
