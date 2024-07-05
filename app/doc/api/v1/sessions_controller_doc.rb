# frozen_string_literal: true

# API module
module Api
  # Version 1 of the APIs
  module V1
    # Documentation for SessionsController
    module SessionsControllerDoc
      extend Apipie::DSL::Concern

      api :POST, '/login', 'Login a user'
      description <<-DESC
        Logs in a user with email and password. Returns the user data and JWT token if successful.
      DESC
      param :user, Hash, desc: 'User credentials', required: true do
        param :email, String, desc: 'Email of the user', required: true
        param :password, String, desc: 'Password of the user', required: true
      end
      example <<-EXAMPLE
      Request Body:
      {
        "user": {
          "email": "user@example.com",
          "password": "password"
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

      api :DELETE, '/logout', 'Logout a user'
      description <<-DESC
        Logs out the currently authenticated user. Returns a success message if successful.
      DESC
      header :Authorization, 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Response Body:
      {
        "messages": ["Logout successfully"]
      }
      EXAMPLE
      def destroy; end
    end
  end
end
