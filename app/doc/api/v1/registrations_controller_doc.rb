# frozen_string_literal: true

# API module
module Api
  # Version 1 of the APIs
  module V1
    # Documentation for SessionsController
    module RegistrationsControllerDoc
      extend Apipie::DSL::Concern

      api :POST, '/signup', 'Register a new user'
      description <<-DESC
        Registers a new user. Returns the user data if successful.
      DESC
      param :user, Hash, desc: 'User registration information', required: true do
        param :email, String, desc: 'Email of the user', required: true
        param :password, String, desc: 'Password of the user', required: true
        param :password_confirmation, String, desc: 'Password confirmation of the user', required: true
        param :name, String, desc: 'Name of the user', required: true
      end
      example <<-EXAMPLE
      Request Body:
      {
        "user": {
          "email": "user@example.com",
          "password": "password",
          "password_confirmation": "password",
          "name": "User Name"
        }
      }

      Response Body:
      {
        "user": {
          "data": {
            "id": "1",
            "type": "user",
            "attributes": {
              "email": "user@example.com",
              "name": "User Name",
              "role": "customer"
            }
          }
        }
      }

      Response Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }
      EXAMPLE
      def create; end
    end
  end
end
