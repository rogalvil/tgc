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
      example <<-EXAMPLE
        {
          "data": [
            {
              "id": 1,
              "email": "user1@example.com",
              "name": "User 1",
              "role": "admin"
            },
            {
              "id": 2,
              "email": "user2@example.com",
              "name": "User 2",
              "role": "customer"
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
      example <<-EXAMPLE
        {
          "data": {
            "id": 1,
            "email": "user@example.com",
            "name": "User 1",
            "role": "customer"
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
      example <<-EXAMPLE
        {
          "data": {
            "id": 1,
            "email": "newuser@example.com",
            "name": "New User",
            "role": "customer"
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
        param :email, String, desc: 'Email of the user', required: false
        param :name, String, desc: 'Name of the user', required: false
        param :password, String, desc: 'Password of the user', required: false
        param :role, String, desc: 'Role of the user', required: false
      end
      example <<-EXAMPLE
        {
          "data": {
            "id": 1,
            "email": "updateduser@example.com",
            "name": "Updated User",
            "role": "customer"
          }
        }
      EXAMPLE
      def update; end

      api :DELETE, '/users/:id', 'Delete a user'
      description <<-DESC
        Deletes a specific user. Only admins can delete users.
      DESC
      param :id, :number, desc: 'ID of the user', required: true
      def destroy; end
    end
  end
end
