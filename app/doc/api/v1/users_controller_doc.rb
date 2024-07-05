# frozen_string_literal: true

# API module
module Api
  # Version 1 of the APIs
  module V1
    # Users controller documentation
    module UsersControllerDoc
      extend Apipie::DSL::Concern

      api :GET, '/users', 'Retrieve all users'
      description <<-DESC
        Retrieves a list of all users. Only admins can access this endpoint.
      DESC
      header 'Authorization', 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Response Body:
      {
        "data": [
          {
            "id": "1",
            "type": "user",
            "attributes": {
              "email": "user1@example.com",
              "name": "User One",
              "role": "admin"
            }
          },
          {
            "id": "2",
            "type": "user",
            "attributes": {
              "email": "user2@example.com",
              "name": "User Two",
              "role": "customer"
            }
          }
        ]
      }
      EXAMPLE
      def index; end

      api :GET, '/users/:id', 'Retrieve a user'
      description <<-DESC
        Retrieves the details of a specific user. Only admins and the user themselves can access this endpoint.
      DESC
      param :id, :number, desc: 'ID of the user', required: true
      header 'Authorization', 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Response Body:
      {
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
      EXAMPLE
      def show; end

      api :POST, '/users', 'Create a new user'
      description <<-DESC
        Creates a new user. Only admins can create users.
      DESC
      param :user, Hash, desc: 'User information', required: true do
        param :email, String, desc: 'Email of the user', required: true
        param :name, String, desc: 'Name of the user', required: true
        param :password, String, desc: 'Password of the user', required: true
      end
      header 'Authorization', 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Request Body:
      {
        "user": {
          "name": "User Name",
          "email": "user@example.com",
          "password": "password"
        }
      }

      Response Body:
      {
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
      EXAMPLE
      def create; end

      api :PATCH, '/users/:id', 'Update a user'
      description <<-DESC
        Updates the details of a specific user. Only admins and the user themselves can update this endpoint.
      DESC
      param :id, :number, desc: 'ID of the user', required: true
      param :user, Hash, desc: 'User information', required: true do
        param :name, String, desc: 'Name of the user', required: false
      end
      header 'Authorization', 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Request Body:
      {
        "user": {
          "name": "Updated User"
        }
      }

      Response Body:
      {
        "data": {
          "id": "1",
          "type": "user",
          "attributes": {
            "email": "updateduser@example.com",
            "name": "Updated User",
            "role": "customer"
          }
        }
      }
      EXAMPLE
      def update; end

      api :DELETE, '/users/:id', 'Delete a user'
      description <<-DESC
        Deletes a specific user. Only admins can delete users.
      DESC
      param :id, :number, desc: 'ID of the user', required: true
      header 'Authorization', 'Bearer token', required: true
      example <<-EXAMPLE
      Request Headers:
      {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9..."
      }

      Response Body:
      (No content, status: 204)
      EXAMPLE
      def destroy; end
    end
  end
end
