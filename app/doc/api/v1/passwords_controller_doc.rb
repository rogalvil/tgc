# frozen_string_literal: true

# API module
module Api
  # Version 1 of the APIs
  module V1
    # Documentation for PasswordsController
    module PasswordsControllerDoc
      extend Apipie::DSL::Concern

      api :POST, '/password', 'Send reset password instructions'
      description <<-DESC
        Sends reset password instructions to the user's email.
        The user will receive an email with the reset token.
      DESC
      param :user, Hash, desc: 'User information', required: true do
        param :email, String, desc: 'Email of the user', required: true
      end
      example <<-EXAMPLE
      Request Body:
      {
        "user": {
          "email": "user@example.com"
        }
      }

      Response Body:
      {
        "message": "Instructions have been sent to your email with the reset token."
      }
      EXAMPLE
      def create; end

      api :PATCH, '/password', 'Reset password'
      description <<-DESC
        Resets the user's password using the reset password token.
      DESC
      param :user, Hash, desc: 'User information', required: true do
        param :password, String, desc: 'New password of the user', required: true
        param :password_confirmation, String, desc: 'Password confirmation', required: true
        param :reset_password_token, String, desc: 'Reset password token', required: true
      end
      example <<-EXAMPLE
      Request Body:
      {
        "user": {
          "password": "newpassword",
          "password_confirmation": "newpassword",
          "reset_password_token": "faketoken123"
        }
      }

      Response Body:
      {
        "message": "Your password has been successfully changed."
      }
      EXAMPLE
      def update; end
    end
  end
end
